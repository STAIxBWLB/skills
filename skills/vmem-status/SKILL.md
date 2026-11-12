---
name: vmem-status
description: Use when asked which vmem version is installed, whether vmem is up to date, or whether its vaults and registry are healthy. Reports the running vmem build against this bundle's floor, other installs on PATH, registered vaults and doctor findings, read-only.
---

# vmem-status

Answer "what vmem runs here and is it healthy" in one report. Every step is read-only: give repairs as commands for the person to run.

## Process

1. **Build**: run `vmem --version`. Read `requires.vmem` from `manifest.json` at the bundle root (beside `lib/`) and compare; when it cannot be read, report the floor as unknown. Below the floor, the vault skills in this bundle stop; say so.
2. **Other installs**: list every `vmem` on PATH (`which -a vmem`, `where vmem` on Windows) and run `--version` on each distinct resolved file. An install whose version differs from the one in step 1 is stale: it runs whenever PATH order changes.
3. **Registry**: run `vmem status --json`. Take `version`, `home`, `source`, `healthy`, and per vault `id`, `kind`, `write`, `pii`, `healthy`, `path`.
4. **Doctor**: run `vmem doctor --json`. Exit code 1 means unhealthy, a finding to report, not a failure of this skill. Report every check that is not ok.
5. **MCP**: when the vmem MCP tools are available, call `vmem_status`. A vault list that differs from step 3 means the MCP server runs another build or home; report it.

## Output

- One line: running version, bundle floor, verdict (ok, upgrade needed).
- Other installs with versions, only when step 2 found any.
- Vaults table: id, kind, write, pii, health, path.
- Doctor findings that are not ok; "healthy" when there are none.
- At most one next action with its command: upgrade below the floor, `vmem recover` (preview) for a stale lock or leftover temp files, removing a stale install with the package manager that owns it.
