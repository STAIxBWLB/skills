# Bootstrap Design Tokens Prompt

Paste this into Claude or any capable LLM with your CSS/Tailwind project files attached. The model will extract design tokens you can copy into `vault/notes/design-tokens.md`.

---

You are helping me consolidate design tokens across my projects. Each project may have its own theme, but I want to identify a **shared base palette** and **per-project variants**.

**Sources to read**:
1. `tailwind.config.{js,ts,cjs,mjs}` — `theme.extend`, custom colors, fonts
2. CSS files with `:root`, `@theme`, `@layer base` declarations
3. `globals.css`, `theme.css`, `tokens.css`, `vars.css`
4. SCSS/Less variable files
5. CSS-in-JS theme objects (styled-components, emotion, vanilla-extract)

**Output format** (Tailwind v4 `@theme` syntax):

```css
@theme {
  /* base palette (most common across projects) */
  --color-bg: <value>;
  --color-fg: <value>;
  --color-accent: <value>;
  --color-muted: <value>;
  --color-border: <value>;

  --font-sans: <value>;
  --font-serif: <value>;
  --font-mono: <value>;

  --radius-sm: <value>;
  --radius-md: <value>;
  --radius-lg: <value>;

  --shadow-soft: <value>;
  --shadow-hard: <value>;
}
```

Then a per-project variant table:

```markdown
| Project ID | Token | Base value | Override value | Reason (if known) |
|-----------|-------|------------|----------------|-------------------|
| ... | --color-accent | oklch(...) | oklch(...) | brand differs |
```

**Rules**:
- Convert hex/rgb/hsl to **oklch** when possible (better perceptual uniformity)
- Pick the **most-used value** as base; treat outliers as variants
- Group by semantic role (color/font/radius/shadow), not by literal hue
- If a project has 4+ deviations from base, recommend a separate token file
- Flag any inline magic numbers (e.g. `box-shadow: 0 4px 8px rgba(0,0,0,0.1)`) that should become tokens

After producing the output, list the top 3 inconsistencies you noticed (e.g. "3 different blue accents across projects — consider unifying").
