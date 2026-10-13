#!/usr/bin/env node
// Behavior eval runner for skills (issue #79). Not part of the OTA bundle.
//
//   node evals/run.mjs [--case <skill>/<case>]... [--runs 3] [--variant current|control|<git-ref>]...
//                      [--budget 0.50] [--model <m>] [--timeout 600] [--agent <executable>]
//
// Each run copies a case fixture into a fresh temp dir, runs the host CLI
// headless there with an isolated CLAUDE_CONFIG_DIR and HOME that hold only the
// skill under test, then grades the workspace tree diff against expect.json.
// Runs are serial by design. Exit 1 when any run performs a forbidden action.
import { execFileSync, spawnSync } from "node:child_process";
import { createHash } from "node:crypto";
import { cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const evalsRoot = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(evalsRoot, "..");

function fail(msg, code = 2) {
  console.error(`skills-eval: ${msg}`);
  process.exit(code);
}

function parseArgs(argv) {
  const args = { cases: [], variants: [], runs: 3, budget: "0.50", timeout: 600 };
  for (let i = 0; i < argv.length; i++) {
    const [flag, value] = [argv[i], argv[i + 1]];
    if (value === undefined) fail(`missing value for ${flag}`);
    if (flag === "--case") args.cases.push(value);
    else if (flag === "--variant") args.variants.push(value);
    else if (flag === "--runs") args.runs = Number.parseInt(value, 10);
    else if (flag === "--budget") args.budget = value;
    else if (flag === "--model") args.model = value;
    else if (flag === "--timeout") args.timeout = Number.parseInt(value, 10);
    else if (flag === "--agent") args.agent = resolve(value);
    else fail(`unknown argument: ${flag}`);
    i++;
  }
  if (!(args.runs >= 1)) fail("--runs must be >= 1");
  if (args.variants.length === 0) args.variants.push("current");
  return args;
}

function discoverCases(filter) {
  const cases = [];
  for (const skill of readdirSync(evalsRoot).sort()) {
    const skillDir = join(evalsRoot, skill);
    if (!statSync(skillDir).isDirectory()) continue;
    for (const name of readdirSync(skillDir).sort()) {
      const dir = join(skillDir, name);
      if (existsSync(join(dir, "expect.json"))) cases.push({ id: `${skill}/${name}`, skill, dir });
    }
  }
  const picked = filter.length ? cases.filter((c) => filter.includes(c.id)) : cases;
  if (picked.length === 0) fail(`no cases matched ${filter.join(", ") || "evals/*/*/expect.json"}`);
  return picked;
}

// path -> sha256 for every file under root.
function snapshot(root) {
  const out = new Map();
  const walk = (dir) => {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const abs = join(dir, entry.name);
      if (entry.isDirectory()) walk(abs);
      else out.set(relative(root, abs), createHash("sha256").update(readFileSync(abs)).digest("hex"));
    }
  };
  walk(root);
  return out;
}

function diffTrees(before, after) {
  const changes = [];
  for (const [path, hash] of after) {
    if (!before.has(path)) changes.push({ path, kind: "added" });
    else if (before.get(path) !== hash) changes.push({ path, kind: "modified" });
  }
  for (const path of before.keys()) if (!after.has(path)) changes.push({ path, kind: "deleted" });
  return changes.sort((a, b) => a.path.localeCompare(b.path));
}

// A change is forbidden when it hits a forbidden prefix or leaves every allowed prefix.
function grade(expect, changes, readFile) {
  const under = (path, prefixes) => (prefixes ?? []).some((p) => path === p || path.startsWith(p));
  const forbidden = changes.filter((c) => under(c.path, expect.forbidden) || !under(c.path, expect.allowed));
  const failures = forbidden.map((c) => `forbidden ${c.kind}: ${c.path}`);
  for (const req of expect.required ?? []) {
    const re = new RegExp(req.pattern);
    const hits = changes.filter((c) => c.kind === "added" && re.test(c.path));
    if (req.count !== undefined && hits.length !== req.count) {
      failures.push(`expected ${req.count} new file(s) matching ${req.pattern}, got ${hits.length}`);
    }
    for (const hit of hits) {
      const text = readFile(hit.path);
      for (const pat of req.contains ?? []) if (!new RegExp(pat, "m").test(text)) failures.push(`${hit.path} lacks /${pat}/`);
      for (const pat of req.absent ?? []) if (new RegExp(pat, "m").test(text)) failures.push(`${hit.path} has /${pat}/`);
    }
  }
  return { pass: failures.length === 0, forbidden: forbidden.length, failures };
}

// The isolated runs never read the real config dir or keychain, so the host CLI
// only authenticates through an env credential the caller passes in.
const AUTH_ENV = ["ANTHROPIC_API_KEY", "CLAUDE_CODE_OAUTH_TOKEN"];

// --restricted ignores user skills, so the skill under test ships as a
// session-only plugin inside the isolated config dir (invoked as eval:<skill>).
function installSkill(variant, skill, configDir, scratch) {
  if (variant === "control") return null;
  const pluginDir = join(configDir, "eval-plugin");
  const dest = join(pluginDir, "skills", skill);
  mkdirSync(join(pluginDir, ".claude-plugin"), { recursive: true });
  writeFileSync(join(pluginDir, ".claude-plugin", "plugin.json"), '{"name":"eval"}\n');
  let src = join(repoRoot, "skills", skill);
  if (variant !== "current") {
    const tar = execFileSync("git", ["-C", repoRoot, "archive", "--format=tar", variant, `skills/${skill}`]);
    const out = join(scratch, "ref");
    mkdirSync(out, { recursive: true });
    execFileSync("tar", ["-x", "-C", out], { input: tar });
    src = join(out, "skills", skill);
  }
  cpSync(src, dest, { recursive: true });
  return pluginDir;
}

function runOnce(c, variant, index, args, root) {
  const scratch = join(root, `${c.id.replace("/", "-")}-${variant.replace(/[^\w.-]/g, "_")}-${index}`);
  const ws = join(scratch, "ws");
  const configDir = join(scratch, "config");
  const home = join(scratch, "home");
  cpSync(join(c.dir, "fixture"), ws, { recursive: true });
  mkdirSync(configDir, { recursive: true });
  mkdirSync(home, { recursive: true });
  const pluginDir = installSkill(variant, c.skill, configDir, scratch);

  const prompt = readFileSync(join(c.dir, "prompt.md"), "utf8");
  const env = { PATH: process.env.PATH, HOME: home, TMPDIR: scratch, LANG: "en_US.UTF-8", CLAUDE_CONFIG_DIR: configDir };
  for (const key of AUTH_ENV) if (process.env[key]) env[key] = process.env[key];
  const cliArgs = [
    "-p", prompt,
    "--output-format", "stream-json", "--verbose",
    "--max-budget-usd", args.budget,
    "--restricted",
    "--tools", "Read,Write,Edit,Glob,Grep,Skill",
    "--permission-mode", "acceptEdits",
    "--permission-prompts", "none",
    "--strict-mcp-config",
    "--no-session-persistence",
    ...(pluginDir ? ["--plugin-dir", pluginDir] : []),
    ...(args.model ? ["--model", args.model] : []),
  ];

  const before = snapshot(ws);
  const started = Date.now();
  const proc = spawnSync(args.agent ?? "claude", cliArgs, { cwd: ws, env, encoding: "utf8", timeout: args.timeout * 1000, maxBuffer: 64 << 20 });
  const seconds = (Date.now() - started) / 1000;
  writeFileSync(join(scratch, "transcript.jsonl"), proc.stdout ?? "");
  writeFileSync(join(scratch, "stderr.txt"), `${proc.stderr ?? ""}${proc.error ? `\n${proc.error}` : ""}`);

  let cost = null;
  let skillUsed = false;
  let skillLoaded = false;
  for (const line of (proc.stdout ?? "").split("\n")) {
    if (!line.startsWith("{")) continue;
    let msg;
    try { msg = JSON.parse(line); } catch { continue; }
    if (msg.type === "result" && typeof msg.total_cost_usd === "number") cost = msg.total_cost_usd;
    if (msg.type === "system" && msg.subtype === "init") skillLoaded = (msg.skills ?? []).includes(`eval:${c.skill}`);
    for (const block of msg.message?.content ?? []) if (block.type === "tool_use" && block.name === "Skill") skillUsed = true;
  }

  const changes = diffTrees(before, snapshot(ws));
  const expect = JSON.parse(readFileSync(join(c.dir, "expect.json"), "utf8"));
  const result = grade(expect, changes, (p) => readFileSync(join(ws, p), "utf8"));
  // Without this, a skill that failed to load would silently turn the run into a control.
  if (pluginDir && !args.agent && !skillLoaded) result.failures.push(`skill eval:${c.skill} not loaded`);
  if (proc.status !== 0) result.failures.push(`agent exit ${proc.status ?? proc.signal ?? proc.error?.code}`);
  result.pass = result.failures.length === 0;
  writeFileSync(join(scratch, "grade.json"), `${JSON.stringify({ changes, ...result, seconds, cost, skillUsed }, null, 2)}\n`);
  return { ...result, seconds, cost, skillUsed, scratch };
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const cases = discoverCases(args.cases);
  if (!args.agent && !AUTH_ENV.some((k) => process.env[k])) {
    fail(`isolated runs need ${AUTH_ENV.join(" or ")} in the environment; the real config dir and keychain are never read`);
  }
  const root = mkdtempSync(join(tmpdir(), "skills-eval-"));
  // A temp dir inside a git work tree would let the agent discover that repo.
  if (spawnSync("git", ["-C", root, "rev-parse", "--is-inside-work-tree"], { stdio: "ignore" }).status === 0) {
    fail(`temp dir ${root} is inside a git work tree; set TMPDIR elsewhere`);
  }

  const rows = [];
  let forbiddenTotal = 0;
  for (const c of cases) {
    for (const variant of args.variants) {
      const runs = [];
      for (let i = 1; i <= args.runs; i++) {
        const r = runOnce(c, variant, i, args, root);
        runs.push(r);
        console.error(`[${c.id} ${variant} ${i}/${args.runs}] ${r.pass ? "pass" : "FAIL"} forbidden=${r.forbidden} ${r.seconds.toFixed(1)}s ${r.scratch}`);
        for (const f of r.failures) console.error(`    ${f}`);
      }
      const forbidden = runs.reduce((n, r) => n + r.forbidden, 0);
      forbiddenTotal += forbidden;
      const costs = runs.map((r) => r.cost).filter((x) => x !== null);
      rows.push([
        c.id,
        variant,
        runs[0].pass ? "yes" : "no",
        `${runs.filter((r) => r.pass).length}/${runs.length}`,
        String(forbidden),
        `${runs.filter((r) => r.skillUsed).length}/${runs.length}`,
        (runs.reduce((s, r) => s + r.seconds, 0) / runs.length).toFixed(1),
        costs.length ? costs.reduce((s, x) => s + x, 0).toFixed(4) : "-",
      ]);
    }
  }

  const header = ["case", "variant", "first-try pass", "passes", "forbidden actions", "skill invoked", "mean duration (s)", "total cost (USD)"];
  console.log([header, header.map(() => "---"), ...rows].map((r) => `| ${r.join(" | ")} |`).join("\n"));
  console.log(`\nrun artifacts: ${root}`);
  process.exit(forbiddenTotal > 0 ? 1 : 0);
}

main();
