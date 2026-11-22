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
  const section = new RegExp(`^## \\[${escaped}\\] - \\d{4}-\\d{2}-\\d{2}[ \\t]*(?:\\r?\\n|$)([\\s\\S]*?)(?=^## \\[|$(?![\\s\\S]))`, "m").exec(changelog);
  if (!section) throw new Error(`CHANGELOG.md lacks the ${version} section; add reviewed release notes before tagging`);
  if (!section[1].replace(/^\s*<!--[^]*?-->\s*$/gm, "").replace(/^\s*#{3,6}\s+.*$/gm, "").trim()) {
    throw new Error(`CHANGELOG.md ${version} section is empty; add reviewed release notes before tagging`);
  }
  return section[1].trim() + "\n";
}
function onMain(run = () => execFileSync("git", ["merge-base", "--is-ancestor", "HEAD", "refs/remotes/origin/main"], { stdio: "ignore" })) {
  try { run(); return true; } catch (error) {
    if (error.status === 1) return false;
    throw new Error("git ancestry check failed; check that the checkout has origin/main and retry");
  }
}
if (process.argv[2] === "--self-test") {
  const notes = "## [1.0.0] - 2026-11-22\n\n- Initial\n\n## [0.9.0] - 2026-01-01\n- Old\n";
  assert.equal(check("v1.0.0", "1.0.0", notes, true), "- Initial\n");
  assert.throws(() => check("v1.0.0", "1.0.0", notes, false), /not on main/);
  assert.throws(() => check("v1.0.1", "1.0.0", notes, true), /does not match/);
  assert.throws(() => check("v1.0.0", "1.0.0", "", true), /lacks/);
  assert.throws(() => check("v1.0.0", "1.0.0", "## [1.0.0] - 2026-11-22", true), /empty/);
  assert.throws(() => check("v1.0.0", "1.0.0", "## [1.0.0] - 2026-11-22\n\n## [0.9.0] - 2026-01-01\n", true), /empty/);
  assert.equal(onMain(() => { throw { status: 1 }; }), false);
  assert.throws(() => onMain(() => { throw { status: 128 }; }), /git ancestry check failed/);
  console.log("release-tag-check self-test ok");
} else {
  try {
    const isOnMain = onMain();
    const manifest = JSON.parse(readFileSync("manifest.json", "utf8"));
    const notes = check(process.env.GITHUB_REF_NAME, manifest.bundleVersion, readFileSync("CHANGELOG.md", "utf8"), isOnMain);
    writeFileSync("release-notes.txt", notes);
  } catch (error) { console.error(`release-tag-check: ${error.message}`); process.exitCode = 1; }
}
