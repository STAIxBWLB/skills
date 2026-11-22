#!/usr/bin/env node
import { readFileSync, writeFileSync } from "node:fs";
import { execFileSync } from "node:child_process";
import assert from "node:assert/strict";

const semver = /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/;
function parts(value) {
  if (typeof value !== "string" || !semver.test(value)) throw new Error(`invalid version ${value}; use VERSION=X.Y.Z`);
  return value.split(".").map(BigInt);
}
function prepare(manifest, changelog, version, date) {
  if (!version) throw new Error("VERSION is missing; run make release-prepare VERSION=X.Y.Z");
  const next = parts(version);
  let current;
  try { current = parts(manifest.bundleVersion); } catch {
    throw new Error(`manifest.json bundleVersion ${manifest.bundleVersion} is invalid; set it to X.Y.Z in manifest.json in a reviewed PR`);
  }
  let greater = false;
  for (let i = 0; i < 3; i++) {
    if (next[i] !== current[i]) { greater = next[i] > current[i]; break; }
  }
  if (!greater) throw new Error(`version ${version} is not greater than ${manifest.bundleVersion}; choose a higher VERSION`);
  const match = /^## \[Unreleased\][ \t]*(?:\r?\n|$)([\s\S]*?)(?=^## \[|$(?![\s\S]))/m.exec(changelog);
  if (!match) throw new Error("CHANGELOG.md lacks an Unreleased section; add one before preparing");
  const content = match[1].replace(/^\s*<!--[^]*?-->\s*$/gm, "").replace(/^\s*#{3,6}\s+.*$/gm, "").trim();
  if (!content) throw new Error("Unreleased is empty; add notes under ## [Unreleased] in CHANGELOG.md, then rerun");
  const heading = `## [Unreleased]\n\n## [${version}] - ${date}\n`;
  return { manifest: { ...manifest, bundleVersion: version }, changelog: changelog.slice(0, match.index) + heading + match[1] + changelog.slice(match.index + match[0].length) };
}
function draft(run = (args) => execFileSync("git", args, { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] })) {
  run(["rev-parse", "--git-dir"]);
  let tag;
  try { tag = run(["describe", "--tags", "--abbrev=0", "--match", "v[0-9]*"]).trim(); } catch { tag = null; }
  const args = ["log", "--format=%s", ...(tag ? [`${tag}..HEAD`] : ["-50", "HEAD"])];
  const subjects = run(args).split("\n").filter((s) => /^(feat|fix|perf|refactor|docs|build|ci|chore)(\([^)]*\))?!?: /.test(s));
  const prefix = tag ? "" : "Draft capped at the most recent 50 commit subjects (no version tag).\n";
  return prefix + (subjects.map((s) => `- ${s}`).join("\n") || "- No conventional-commit subjects found.");
}
function localDate(date) {
  return [date.getFullYear(), String(date.getMonth() + 1).padStart(2, "0"), String(date.getDate()).padStart(2, "0")].join("-");
}
function selfTest() {
  const input = { bundleVersion: "1.0.0" };
  assert.equal(localDate(new Date(2026, 10, 22)), "2026-11-22");
  assert.throws(() => prepare({ bundleVersion: "bad" }, "", "1.0.1", "2026-11-22"), /manifest.json bundleVersion bad is invalid/);
  const log = "# Changelog\n\n## [Unreleased]\n\n### Fixed\n\n- Example\n\n## [1.0.0] - 2026-01-01\n\n- Initial\n";
  const result = prepare(input, log, "1.0.1", "2026-11-22");
  assert.equal(result.manifest.bundleVersion, "1.0.1");
  assert.match(result.changelog, /## \[Unreleased\]\n\n## \[1\.0\.1\] - 2026-11-22\n\n### Fixed/);
  for (const value of ["1.0.0", "0.9.9", "1.01.0", "x"]) assert.throws(() => prepare(input, log, value, "2026-11-22"));
  assert.throws(() => prepare(input, "## [Unreleased]\n\n## [1.0.0] - 2026-01-01\n", "1.0.1", "2026-11-22"), /empty/);
  assert.throws(() => prepare(input, "## [Unreleased]", "1.0.1", "2026-11-22"), /empty/);
  assert.throws(() => prepare(input, log, "", "2026-11-22"), /VERSION is missing/);
  let logArgs;
  const sampleDraft = draft((args) => { if (args[0] === "describe") throw new Error("no tags"); if (args[0] === "log") { logArgs = args; return "fix: example\n"; } return ".git"; });
  assert.ok(logArgs.includes("-50"));
  assert.match(sampleDraft, /capped at the most recent 50/);
  console.log("release-prepare self-test ok");
}
if (process.argv[2] === "--self-test") selfTest();
else {
  try {
    const manifest = JSON.parse(readFileSync("manifest.json", "utf8"));
    const changelog = readFileSync("CHANGELOG.md", "utf8");
    const result = prepare(manifest, changelog, process.argv[2], localDate(new Date()));
    writeFileSync("manifest.json", `${JSON.stringify(result.manifest, null, 2)}\n`);
    writeFileSync("CHANGELOG.md", result.changelog);
    console.log(`Prepared ${process.argv[2]}; review and submit the changes in a PR.`);
  } catch (error) {
    console.error(`release-prepare: ${error.message}`);
    if (/Unreleased is empty/.test(error.message)) {
      try { console.error(`Draft conventional-commit subjects:\n${draft()}`); }
      catch { console.error("Cannot generate draft: git history is unavailable; check the checkout and add notes manually."); }
    }
    process.exitCode = 1;
  }
}
