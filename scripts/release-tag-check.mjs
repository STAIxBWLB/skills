#!/usr/bin/env node
import { readFileSync, writeFileSync } from "node:fs";
import { execFileSync } from "node:child_process";
import assert from "node:assert/strict";

function check(tag, version, changelog, onMain) {
  if (!onMain) throw new Error("tag commit is not on main; merge the release PR before tagging");
  if (typeof version !== "string" || !/^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/.test(version) || tag !== `v${version}`) {
    throw new Error(`tag ${tag} does not match manifest bundleVersion ${version}; tag the reviewed version`);
  }
  const escaped = version.replaceAll(".", "\\.");
  const section = new RegExp(`^## \\[${escaped}\\] - \\d{4}-\\d{2}-\\d{2}\\s*\\n([\\s\\S]*?)(?=^## \\[|$(?![\\s\\S]))`, "m").exec(changelog);
  if (!section) throw new Error(`CHANGELOG.md lacks the ${version} section; add reviewed release notes before tagging`);
  return section[1].trim() + "\n";
}
if (process.argv[2] === "--self-test") {
  const notes = "## [1.0.0] - 2026-11-22\n\n- Initial\n\n## [0.9.0] - 2026-01-01\n- Old\n";
  assert.equal(check("v1.0.0", "1.0.0", notes, true), "- Initial\n");
  assert.throws(() => check("v1.0.0", "1.0.0", notes, false), /not on main/);
  assert.throws(() => check("v1.0.1", "1.0.0", notes, true), /does not match/);
  assert.throws(() => check("v1.0.0", "1.0.0", "", true), /lacks/);
  console.log("release-tag-check self-test ok");
} else {
  try {
    let onMain = true;
    try { execFileSync("git", ["merge-base", "--is-ancestor", "HEAD", "refs/remotes/origin/main"], { stdio: "ignore" }); } catch { onMain = false; }
    const manifest = JSON.parse(readFileSync("manifest.json", "utf8"));
    const notes = check(process.env.GITHUB_REF_NAME, manifest.bundleVersion, readFileSync("CHANGELOG.md", "utf8"), onMain);
    writeFileSync("release-notes.txt", notes);
  } catch (error) { console.error(`release-tag-check: ${error.message}`); process.exitCode = 1; }
}
