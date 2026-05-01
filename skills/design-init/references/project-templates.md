# Project Templates Reference

INTENSITY × DARKNESS × TYPE 조합별 템플릿 기준.

## global.css 템플릿 — Minimal (INTENSITY 1-2)

```css
@import "tailwindcss";

@theme {
  --font-sans: 'Pretendard Variable', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, monospace;
}

:root {
  --color-text: #0f172a;
  --color-text-muted: #64748b;
  --color-border: #e2e8f0;
  --color-accent: #2563eb;
}

:lang(ko) {
  word-break: keep-all;
  overflow-wrap: break-word;
}

html { scroll-behavior: smooth; }

body {
  font-family: var(--font-sans);
  color: var(--color-text);
  line-height: 1.7;
  -webkit-font-smoothing: antialiased;
}

.skip-link {
  position: absolute;
  top: -100%;
  left: 1rem;
  z-index: 9999;
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  background: var(--color-accent);
  color: #fff;
  font-size: 0.875rem;
  font-weight: 600;
  text-decoration: none;
  transition: top 0.1s;
}
.skip-link:focus { top: 1rem; }

:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
}

::selection {
  background-color: rgba(37,99,235,0.25);
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## global.css 템플릿 — Full (INTENSITY 4-5, DARKNESS both)

```css
@import "tailwindcss";
@import "./fonts.css";

@plugin "@tailwindcss/typography";

@custom-variant dark (&:where(.dark, .dark *));

@theme {
  --font-sans: 'Space Grotesk', 'Pretendard Variable', system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
  --color-accent-blue: #2563eb;
  --color-accent-cyan: #22d3ee;
  --color-accent-orange: #f97316;
}

:root {
  --color-bg-primary: #f8fafc;
  --color-bg-surface: #f1f5f9;
  --color-text-primary: #0f172a;
  --color-text-secondary: #475569;
  --color-text-muted: #94a3b8;
  --color-border: rgba(15,23,42,0.08);
  --shadow-sm: 0 1px 2px rgba(15,23,42,0.06);
  --shadow-md: 0 4px 12px rgba(15,23,42,0.08);
}

.dark {
  --color-bg-primary: #080808;
  --color-bg-surface: #111111;
  --color-text-primary: #f0f0f0;
  --color-text-secondary: #a0a0a0;
  --color-text-muted: #666666;
  --color-border: rgba(255,255,255,0.08);
  --shadow-sm: none;
  --shadow-md: none;
}

/* (이하 모든 INTENSITY 5 요소 포함) */
```

## fonts.css 템플릿

```css
/* Pretendard Variable — self-hosted subset (Korean + Latin) */
@font-face {
  font-family: "Pretendard Variable";
  font-weight: 100 900;
  font-display: swap;
  font-style: normal;
  src: url("/fonts/PretendardVariable.woff2") format("woff2-variations");
  unicode-range: U+0020-007E, U+AC00-D7A3, U+1100-11FF, U+3130-318F;
}

/* Space Grotesk — loaded via Google Fonts 또는 self-hosted */
/* JetBrains Mono — loaded via Google Fonts 또는 self-hosted */
```

## Base.astro 템플릿 구조

```astro
---
// Base.astro
interface Props {
  title: string;
  description?: string;
  ogImage?: string;
}
const { title, description = '', ogImage } = Astro.props;
---
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{title}</title>
  <meta name="description" content={description} />
  <!-- fonts (Google Fonts link 또는 self-hosted) -->
  <!-- global CSS -->
</head>
<body class="grain"> <!-- INTENSITY 5 시 grain -->
  <a href="#main" class="skip-link">본문 바로가기</a>
  <!-- header -->
  <main id="main">
    <slot />
  </main>
  <!-- footer -->
  <!-- scroll reveal script (INTENSITY 3+) -->
  <!-- dark mode toggle script (DARKNESS=both) -->
</body>
</html>
```

## 필수 폰트 파일

`public/fonts/`에 배치:
- `PretendardVariable.woff2` (한글 + 라틴 subset, ~2.5MB)
- `SpaceGrotesk-Variable.woff2` (영문, ~50KB) — INTENSITY 4+ 시

다운로드:
- Pretendard: https://github.com/orioncactus/pretendard
- Space Grotesk: Google Fonts
