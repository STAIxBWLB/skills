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
  const next = parts(version), current = parts(manifest.bundleVersion);
  let greater = false;
  for (let i = 0; i < 3; i++) {
    if (next[i] !== current[i]) { greater = next[i] > current[i]; break; }
  }
  if (!greater) throw new Error(`version ${version} is not greater than ${manifest.bundleVersion}; choose a higher VERSION`);
  const match = /^## \[Unreleased\][ \t]*\r?\n([\s\S]*?)(?=^## \[|$(?![\s\S]))/m.exec(changelog);
  if (!match) throw new Error("CHANGELOG.md lacks an Unreleased section; add one before preparing");
  const content = match[1].replace(/^\s*<!--[^]*?-->\s*$/gm, "").replace(/^\s*#{3,6}\s+.*$/gm, "").trim();
  if (!content) throw new Error("Unreleased is empty; edit the draft below before preparing");
  const heading = `## [Unreleased]\n\n## [${version}] - ${date}\n`;
  return { manifest: { ...manifest, bundleVersion: version }, changelog: changelog.slice(0, match.index) + heading + match[1] + changelog.slice(match.index + match[0].length) };
}
function draft() {
  let range = "HEAD";
  try { range = `${execFileSync("git", ["describe", "--tags", "--abbrev=0", "--match", "v[0-9]*"], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim()}..HEAD`; } catch {}
  const subjects = execFileSync("git", ["log", "--format=%s", range], { encoding: "utf8" }).split("\n").filter((s) => /^(feat|fix|perf|refactor|docs|build|ci|chore)(\([^)]*\))?!?: /.test(s));
  return subjects.map((s) => `- ${s}`).join("\n") || "- No conventional-commit subjects found.";
}
function selfTest() {
  const input = { bundleVersion: "1.0.0" };
  const log = "# Changelog\n\n## [Unreleased]\n\n### Fixed\n\n- Example\n\n## [1.0.0] - 2026-01-01\n\n- Initial\n";
  const result = prepare(input, log, "1.0.1", "2026-11-22");
  assert.equal(result.manifest.bundleVersion, "1.0.1");
  assert.match(result.changelog, /## \[Unreleased\]\n\n## \[1\.0\.1\] - 2026-11-22\n\n### Fixed/);
  for (const value of ["1.0.0", "0.9.9", "1.01.0", "x"]) assert.throws(() => prepare(input, log, value, "2026-11-22"));
  assert.throws(() => prepare(input, "## [Unreleased]\n\n## [1.0.0] - 2026-01-01\n", "1.0.1", "2026-11-22"), /empty/);
  console.log("release-prepare self-test ok");
}
if (process.argv[2] === "--self-test") selfTest();
else {
  try {
    const manifest = JSON.parse(readFileSync("manifest.json", "utf8"));
    const changelog = readFileSync("CHANGELOG.md", "utf8");
    const result = prepare(manifest, changelog, process.argv[2], new Date().toISOString().slice(0, 10));
    writeFileSync("manifest.json", `${JSON.stringify(result.manifest, null, 2)}\n`);
    writeFileSync("CHANGELOG.md", result.changelog);
    console.log(`Prepared ${process.argv[2]}; review and submit the changes in a PR.`);
  } catch (error) {
    console.error(`release-prepare: ${error.message}`);
    if (/Unreleased is empty/.test(error.message)) console.error(`Draft conventional-commit subjects:\n${draft()}`);
    process.exitCode = 1;
  }
}
