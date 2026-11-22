#!/usr/bin/env node
import assert from "node:assert/strict";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const root = mkdtempSync(join(tmpdir(), "bundle-version-"));
try {
  const manifest = JSON.parse(readFileSync("manifest.json", "utf8"));
  for (const version of [undefined, "1.2", "1.02.3"]) {
    const fixture = { ...manifest };
    if (version === undefined) delete fixture.bundleVersion;
    else fixture.bundleVersion = version;
    writeFileSync(join(root, "manifest.json"), JSON.stringify(fixture));
    const run = spawnSync(process.execPath, [resolve("scripts/skills-bundle.mjs"), "verify", "--root", root], { encoding: "utf8" });
    assert.notEqual(run.status, 0);
    assert.match(run.stderr, /bundleVersion missing or invalid/);
  }
  console.log("bundle-version self-test ok");
} finally { rmSync(root, { recursive: true, force: true }); }
