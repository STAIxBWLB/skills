---
name: vault-stats
trigger: /vault-stats
description: Show vault statistics and health overview
---

# /vault-stats

Display comprehensive vault statistics. Numbers only; the "what to do next" recommendation is `/vault-next`.

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

1. Size / MOCs / Activity / Growth: count notes and read each note's type and domain with `vmem_list(limit: 500)`, paged by stem `prefix` (it has no cursor); `vmem_mocs` for MOC sizes. Activity and Growth (created/modified over time) are not in vmem's read fields: take them from `vmem_log_tail` and read-only vault git history, or report them as unavailable. expect: vmem refuses a limit above 500
2. Connections (edges, density, top hubs): read the latest `reports/graph-report-YYMMDD.md` and `reports/graph-trend.md`
3. Orphan count and schema compliance: run `vmem lint <vault> --json` (or `vmem_lint`) and take the L03 / L02 counts (same numbers `/vault-lint vault` reports; `lint.py` stays as the cross-check)
4. Read `ops/sessions/last-sync-timestamp`
5. Assemble metrics

## Output
- Formatted statistics report
- Highlight any metrics outside healthy thresholds
