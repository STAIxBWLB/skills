# Design Skills Overview

A map of design-related skills useful for building modern web frontends. Five skills in this catalog (design-init, design-system, design-review, design-a11y, design-motion) cover the core inner loop; complementary plugins published elsewhere fill in adjacent niches.

## Catalog

### Core (this repo)

| Skill | Purpose |
|-------|---------|
| `design-init` | 5-step preference interview → scaffolds `global.css` + `fonts.css` for a new project |
| `design-system` | Tailwind v4 `@theme` design tokens + project-variant management |
| `design-motion` | Reusable CSS animation patterns catalog (entrances, scroll reveal, hover, press states) |
| `design-review` | `/polish`, `/audit`, `/distill`, `/roadmap` — design-system-driven inspection |
| `design-a11y` | KWCAG 2.2 / WCAG 2.2 audits with Korean-web specifics |

### Complementary plugins (publish destination varies)

These are independent skills/plugins from the wider Claude Code ecosystem that pair well with the core five. Install separately as needed.

| Skill | Niche |
|-------|-------|
| `frontend-design` | Base layer — generic frontend component generation |
| `design-taste-frontend` | Metric-driven UI engineering with three dials (DESIGN_VARIANCE, MOTION_INTENSITY, VISUAL_DENSITY) |
| `high-end-visual-design` | Awwwards-tier output — Vibe + Layout variance engine, three premium archetypes (Ethereal Glass, Editorial Luxury, Soft Structuralism) |
| `redesign-existing-projects` | Strategic audit + upgrade for established sites; eight audit categories with priority sequencing |
| `stitch-design-taste` | Encodes a project's design system into `DESIGN.md` (Google Stitch convention) |
| `make-interfaces-feel-better` | 16 micro-detail principles (concentric radius, optical alignment, staggered entries, pressed states, …) |
| `minimalist-ui` | Editorial warmth — warm monochrome palette, bento grids, ultra-subtle shadows |
| `industrial-brutalist-ui` | Swiss print + CRT terminal — macro typography, rigid grids, halftone effects |
| `Better Icons` | Icon set search and migration (Lucide / Heroicons / Phosphor) |

## Skill dependencies (core)

```
design-system ─┬─ design-review (audits against tokens)
               ├─ design-init   (scaffolds with tokens)
               ├─ design-a11y   (verifies token contrast/sizing)
               └─ design-motion (animation pattern library)
```

`design-system` is the source of truth — the other four read from it.

## Shared design language

These defaults are encoded in the templates (`docs/templates/design-tokens.md`, `docs/templates/motion-library.md`). Override per-project in your own vault.

| Layer | Default |
|-------|---------|
| Display font | Space Grotesk (or Geist, Outfit, Satoshi) |
| Body font | Pretendard (Korean) / Inter alternatives — **never plain Inter** |
| Mono font | JetBrains Mono |
| Primary accent | blue `#2563eb` |
| Secondary accent | cyan `#22d3ee` / `#0ea5e9` |
| Highlight | orange `#f97316` |
| Easing | `cubic-bezier(0.16, 1, 0.3, 1)` (spring-like) |
| Pure black | **avoid** — use `#080808` – `#1a1a1a` |
| Max font-weight | 700 (allow 800/900 only on display copy) |

## Anti-AI-Slop principles

Design output that *looks* generated has a cluster of tells. These principles invert each one.

| Tell | Inversion |
|------|-----------|
| Three identical cards in a row | featured + 2×2 grid (asymmetric variation) |
| Generic copy ("Innovative Solutions", "Empowering Users") | Concrete numbers and named outcomes |
| Perfectly symmetric grids | Intentional asymmetry — staggered offset, span variation |
| Inter as default | Geist / Outfit / Satoshi / Space Grotesk |
| Pure black `#000000` | `#080808` – `#1a1a1a` |
| Neon / purple glow | Tinted shadow, subtle glow tied to brand color |
| Heavy `font-weight: 800` / `900` everywhere | Cap at 700; reserve heavier weights for display headlines |
| Identical-size repeating elements | Mix featured vs. compact |

## Workflows

### New project

```
design-init        → preference interview → global.css + fonts.css
design-system      → tokens reference during component build
design-motion      → animation patterns when adding interaction
design-review /audit → consistency check before merge
design-a11y        → final accessibility pass
```

### Existing-project maintenance

```
design-review /audit → state-of-the-codebase
design-review /polish → visual quality lift
design-a11y         → fix accessibility issues
design-motion       → add interactions where missing
```

### PR review

```
design-review /audit → token consistency vs. design-system
design-a11y         → contrast / focus / Korean text wrapping
```

## Layout

```
skills/
├── design-init/
├── design-system/
├── design-motion/
├── design-review/
└── design-a11y/
    ├── SKILL.md
    └── references/
```

Each skill ships with its `SKILL.md` and supporting `references/`. Templates that the skills consume live in `docs/templates/` (this repo).

## See also

- [`design-skills-workflows.md`](./design-skills-workflows.md) — practical recipes and skill-combination patterns
- [`../vault-setup.md`](../vault-setup.md) — set up a markdown vault so design tokens and roadmaps persist across sessions
