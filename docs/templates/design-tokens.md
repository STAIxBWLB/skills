---
description: Tailwind v4 @theme design tokens with per-project variants
type: reference
domain: design
topics: [design-tokens, tailwind, theming]
---

# Design Tokens

> Used by `design-system` and `design-review` skills to validate token consistency across projects.

## Base palette (default)

```css
@theme {
  --color-bg: oklch(99% 0.005 100);
  --color-fg: oklch(20% 0.02 250);
  --color-accent: oklch(65% 0.18 25);
  --color-muted: oklch(60% 0.01 250);
  --color-border: oklch(90% 0.005 250);

  --font-sans: "Inter Variable", system-ui, sans-serif;
  --font-serif: "Source Serif 4 Variable", Georgia, serif;
  --font-mono: "JetBrains Mono Variable", monospace;

  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 1rem;

  --shadow-soft: 0 1px 3px oklch(0% 0 0 / 0.04), 0 8px 24px oklch(0% 0 0 / 0.04);
  --shadow-hard: 0 1px 2px oklch(0% 0 0 / 0.08);
}
```

## Project variants

Each row = one project's deviation from base.

| Project ID | Token | Override | Reason |
|-----------|-------|----------|--------|
| (example) | --color-accent | oklch(65% 0.18 280) | Brand violet |

Edit this table when a project diverges. `design-system` skill flags drift.

## Add a new variant

1. Use the project ID from `glossary.md` (must exist there)
2. Add row above with the deviating token + new value
3. If 3+ tokens diverge, consider creating a separate `tokens-<project>.md` and link from frontmatter `relates_to`

## Naming conventions

- Color: `--color-<role>` not `--color-<hue>` (semantic over literal)
- Font: `--font-<family>` (sans/serif/mono only at base)
- Radius: 3 steps (sm/md/lg)
- Shadow: 2 steps (soft/hard)

Skills enforce: deviations from base must have a reason listed.
