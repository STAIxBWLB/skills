---
name: vault-stats
trigger: /vault-stats
description: Show vault statistics and health, then recommend the highest-value next action
---

# /vault-stats

> Before the first vmem call, read `lib/vault_adapter.md` §Runtime Discovery and bind the vmem vault id for the workspace `vault.path`; pass it as `vault` on every vmem tool call and as the `<vault>` argument of every `vmem` CLI command.

Display comprehensive vault statistics, then recommend the most valuable next action from them (§Next action). `/vault-stats next` skips the full report and gives only the recommendation.

## Metrics

1. **Size**: total notes, by type, by domain
2. **MOCs**: domain MOC note counts, topic MOC list
3. **Connections**: average links per note, orphan count/ratio
4. **Sync lag**: days since `ops/sessions/last-sync-timestamp`
5. **Activity**: recently created/modified notes
6. **Growth**: notes per week/month trend
7. **Quality**: schema compliance rate

## Process

Do not recompute what the lint/graph pipeline already produces:

1. Size / MOCs / Activity / Growth: `vmem_stats` (notes by type, domain and status, notes modified in the last 7 and 30 days, log events by type); `vmem_mocs` for MOC sizes; the recently created/modified notes themselves from `vmem_log_tail`. Growth beyond those windows: read-only vault git history, or report it as unavailable
2. Connections (edges, density, top hubs): read the latest `reports/graph-report-YYMMDD.md` and `reports/graph-trend.md`
3. Orphan count and schema compliance: run `vmem lint <vault> --json` (or `vmem_lint`) and take the L03 / L02 counts (same numbers `/vault-lint vault` reports)
4. Read `ops/sessions/last-sync-timestamp`
5. Assemble metrics

## Next action

Rank maintenance conditions from the metrics above and recommend one action:

- Orphan notes or island communities → `/vault-connect`
- Notes not updated for more than 90 days → `/vault-update`
- Work sources changed since `ops/sessions/last-sync-timestamp` → `/vault-sync` (or `/vault-sync targets` for a known list)
- Observation or tension count at or above the `ops/config.yaml` thresholds → `/vault-rethink`

Priority: 1. critical (schema violations, broken links); 2. high (unsynced work sources, orphan drift); 3. medium (stale notes, pending observations); 4. low (optimization, MOC refinement).

## Output
- Formatted statistics report
- Highlight any metrics outside healthy thresholds
- Recommended next action with reasoning, estimated effort and the command to run
