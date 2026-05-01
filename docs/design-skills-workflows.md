# Design Skills — Practical Workflows

Recipes for combining the core design skills (this catalog) with complementary external skills. See [`design-skills-overview.md`](./design-skills-overview.md) for the catalog itself.

## Skill selection matrix

| Task | Primary | Support |
|------|---------|---------|
| New project scaffold | `design-init` | `design-taste-frontend` |
| Redesign an existing site | `redesign-existing-projects` | `high-end-visual-design` |
| Micro-detail polish | `make-interfaces-feel-better` | `design-review /polish` |
| Premium / award-tier UI | `high-end-visual-design` | `design-taste-frontend` |
| Minimalist editorial style | `minimalist-ui` | `stitch-design-taste` |
| Brutalist / data-dashboard style | `industrial-brutalist-ui` | — |
| Icon set migration | `Better Icons` | — |
| Accessibility audit | `design-a11y` | external UI-review rules |
| Add motion / interaction | `design-motion` | `make-interfaces-feel-better` |
| Token consistency cleanup | `design-system` | `design-review /audit` |
| PR / code review | `design-review /audit` | external UI-review rules |
| Document the design system | `stitch-design-taste` | `design-system` |

## Workflow recipes

### 1. Existing-site improvement (most common)

```
redesign-existing-projects     → audit, surface improvement points
        ↓
make-interfaces-feel-better    → pressed states, spacing, shadows, alignment
        ↓
design-review /audit           → token-consistency final check
        ↓
design-a11y                    → accessibility verification
```

`redesign-existing-projects` includes AI-slop detection, so it goes first.

### 2. Layout overhaul

```
high-end-visual-design         → asymmetric layout direction; pick an archetype
        ↓
design-system                  → spacing / grid rules from tokens
        ↓
design-motion                  → staggered reveal, scroll patterns
```

Pick exactly one of `high-end-visual-design`'s three layout archetypes (Ethereal Glass, Editorial Luxury, Soft Structuralism), then proceed.

### 3. Detail polish

```
make-interfaces-feel-better    → walk the 16 core principles
        ↓
design-review /polish          → visual quality lift
        ↓
design-review /distill         → strip unused CSS
```

`make-interfaces-feel-better` doubles as a checklist.

### 4. New project from zero

```
design-init                    → 5-step preference interview → global.css + fonts.css
        ↓
design-taste-frontend          → set the three dials (variance / motion / density)
        ↓
stitch-design-taste            → emit DESIGN.md (encoded design system)
        ↓
design-system                  → tokens reference during component build
```

## Skill combination recipes

### Quick polish (≈30 min)

```
make-interfaces-feel-better → design-review /polish
```

Pre-deploy quick pass. Pressed states, spacing, micro-shadows.

### Full audit (≈2 hr)

```
redesign-existing-projects audit → design-a11y → design-review /audit
```

Periodic health check. Structural issues + accessibility + token consistency.

### Premium upgrade (≈half day)

```
high-end-visual-design → design-motion → make-interfaces-feel-better → design-review /audit
```

End-to-end uplift: layout → animation → details → final audit.

### Icon migration (≈1 hr)

```
Better Icons: search → get → replace (component by component)
```

E.g., Lucide → Phosphor. Walk components and verify visually after replacement.

## Anti-pattern fixes

These are the AI-slop tells from `design-skills-overview.md`, paired with the skill that catches each.

| Tell | Skill |
|------|-------|
| Three identical cards in a row | `redesign-existing-projects` |
| Generic copy | `high-end-visual-design` |
| Perfectly symmetric grids | `make-interfaces-feel-better` |
| Inter default | `design-taste-frontend` |
| `#000000` background | `design-system` |
| Neon / purple glow | `high-end-visual-design` |
| Heavy `font-weight` everywhere | `make-interfaces-feel-better` |
| Identical-size repeating elements | `redesign-existing-projects` |

## See also

- [`design-skills-overview.md`](./design-skills-overview.md) — catalog and shared design language
- [`templates/design-tokens.md`](./templates/design-tokens.md) — Tailwind v4 token starter
- [`templates/motion-library.md`](./templates/motion-library.md) — animation pattern catalog
- [`templates/improvement-roadmaps.md`](./templates/improvement-roadmaps.md) — per-project polish backlog
