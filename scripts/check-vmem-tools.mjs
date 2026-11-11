#!/usr/bin/env node
// vmem tool-contract drift check for shipped skill text.
//
//   node scripts/check-vmem-tools.mjs [--snapshot scripts/fixtures/vmem-manifest-<version>.json]
//
// Every `vmem_*` name in the bundle (skills/, lib/, envs/, docs/,
// manifest.json, SKILL_INDEX.md) must be a tool the installed vmem release
// actually exposes, so a skill cannot call a name that release removed or
// never had. The reference is a checked-in snapshot of `vmem manifest --json`,
// never the installed binary: this check runs where vmem is not installed.
//
// Refreshing the snapshot is a manual step, and the floor in manifest.json
// fixes which snapshot is current: its `version` must satisfy
// `requires.vmem`, so raising the floor without a fresh `vmem manifest --json`
// fails here instead of against a stale tool list.

import { readFileSync, readdirSync, existsSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
// Exactly the shipped bundle paths (see scripts/skills-bundle.mjs): repo
// plumbing never reaches a client, so it is not scanned.
const BUNDLE_PATHS = ["skills", "envs", "lib", "docs", "manifest.json", "SKILL_INDEX.md"];
const TOKEN = /\bvmem_[a-z][a-z0-9_]*\b/g;

function fail(message) {
  console.error(`check-vmem-tools: ${message}`);
  process.exit(1);
}

function argValue(flag) {
  const at = process.argv.indexOf(flag);
  return at === -1 ? undefined : process.argv[at + 1];
}

// A manifest mixes read-only tools as {name, readOnly} objects with write
// tools as bare strings. Both shapes are one name; a shape-blind read loses
// every bare string.
function toolNames(manifest) {
  const list = manifest?.mcp?.tools;
  if (!Array.isArray(list)) fail("snapshot has no mcp.tools array");
  return new Set(
    list.map(entry => (typeof entry === "string" ? entry : entry?.name)).filter(name => typeof name === "string"),
  );
}

function markdownFiles(dir, out) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === ".git" || entry.name === "node_modules") continue;
    const path = join(dir, entry.name);
    if (entry.isDirectory()) markdownFiles(path, out);
    else if (/\.(md|mjs|json)$/.test(entry.name)) out.push(path);
  }
  return out;
}

function compareVersions(a, b) {
  const left = a.split(".").map(Number);
  const right = b.split(".").map(Number);
  for (let i = 0; i < 3; i += 1) {
    const diff = (left[i] ?? 0) - (right[i] ?? 0);
    if (diff !== 0) return diff;
  }
  return 0;
}

const floor = JSON.parse(readFileSync(join(repoRoot, "manifest.json"), "utf8"))?.requires?.vmem;
if (typeof floor !== "string" || !/^>=\d+\.\d+\.\d+$/.test(floor)) fail(`manifest.json requires.vmem is not ">=X.Y.Z": ${floor}`);

const snapshotPath = resolve(argValue("--snapshot") ?? join(repoRoot, "scripts", "fixtures", `vmem-manifest-${floor.slice(2)}.json`));
if (!existsSync(snapshotPath)) {
  fail(`no snapshot at ${relative(repoRoot, snapshotPath)}; capture it with \`vmem manifest --json\` on vmem ${floor.slice(2)}`);
}

const snapshot = JSON.parse(readFileSync(snapshotPath, "utf8"));
if (typeof snapshot.version !== "string") fail("snapshot has no version");
if (compareVersions(snapshot.version, floor.slice(2)) < 0) {
  fail(`snapshot version ${snapshot.version} is below the manifest floor ${floor}; capture \`vmem manifest --json\` from ${floor.slice(2)} or newer`);
}

const known = toolNames(snapshot);
const files = [];
for (const path of BUNDLE_PATHS) {
  const abs = join(repoRoot, path);
  if (!existsSync(abs)) continue;
  files.push(...(abs.endsWith(".md") || abs.endsWith(".json") ? [abs] : markdownFiles(abs, [])));
}

const findings = [];
for (const file of files) {
  const text = readFileSync(file, "utf8");
  const lines = text.split("\n");
  lines.forEach((line, index) => {
    for (const [token] of line.matchAll(TOKEN)) {
      if (!known.has(token)) findings.push(`${relative(repoRoot, file)}:${index + 1}: ${token} is not a tool in vmem ${snapshot.version}`);
    }
  });
}

if (findings.length) {
  for (const finding of findings) console.error(finding);
  fail(`${findings.length} unknown vmem tool name(s) against vmem ${snapshot.version} (${known.size} tools)`);
}

console.log(`check-vmem-tools: ok (vmem ${snapshot.version}, ${known.size} tools, ${files.length} bundle files)`);
