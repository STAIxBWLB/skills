---
description: Per-project polish/audit/distill backlog tracked across design-review sessions
type: log
domain: design
topics: [roadmap, design-review, polish]
---

# Improvement Roadmaps

> Used by `design-review` skill (`/roadmap` command) to track outstanding polish/audit/distill items per project. Append-only — completed items move to a `closed` section, not deleted.

## Format

One H2 per project (matches `glossary.md` project ID).

```
## <project-id>

### open
- [ ] {category}: {item} — {date logged}

### closed
- [x] {category}: {item} — {date closed}
```

Categories: `polish`, `audit`, `distill`, `roadmap`, `bug`.

## Example

## project-x

### open
- [ ] polish: hero CTA needs glow variant — 2026-05-01
- [ ] audit: tokens diverge from base in 3 places — 2026-05-01
- [ ] distill: 14% of CSS is unused — 2026-05-01

### closed
- [x] polish: replace stock illustrations with custom SVG — 2026-04-22

---

## How `design-review` writes here

When you run `/polish`, `/audit`, `/distill`, or `/roadmap`:
1. Skill scans the active project
2. Logs each finding as a new `- [ ]` line under `### open`
3. When you fix and rerun, the skill marks items `[x]` and moves them to `### closed`

Manual edits OK — skill respects existing structure.
