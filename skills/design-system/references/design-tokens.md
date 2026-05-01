# Design Tokens Reference

5개 프로젝트에서 추출한 디자인 토큰 통합 reference.

## Color Tokens

### 공통 액센트 (youngjoon-lee.com, staixbwlb.com 공유)

| Token | Light | Dark | 용도 |
|-------|-------|------|------|
| `--color-blue` | #2563eb | #2563eb | Primary accent |
| `--color-blue-light` | #3b82f6 | #3b82f6 | Hover/lighter accent |
| `--color-cyan` | #0ea5e9 | #22d3ee | Secondary accent |
| `--color-cyan-light` | #38bdf8 | #67e8f9 | Lighter cyan |
| `--color-orange` | #f97316 | #f97316 | Warm accent |
| `--color-orange-light` | #fb923c | #fb923c | Lighter orange |

### youngjoon-lee.com 전용

| Token | Light | Dark |
|-------|-------|------|
| `--color-bg-primary` | #f8fafc | #080808 |
| `--color-bg-surface` | #f1f5f9 | #111111 |
| `--color-bg-hover` | #e2e8f0 | #1a1a1a |
| `--color-text-primary` | #0f172a | #f0f0f0 |
| `--color-text-secondary` | #475569 | #a0a0a0 |
| `--color-text-tertiary` | #94a3b8 | #666666 |
| `--color-border` | rgba(15,23,42,0.08) | rgba(255,255,255,0.08) |
| `--color-border-accent` | rgba(37,99,235,0.3) | rgba(37,99,235,0.4) |

### staixbwlb.com 전용 (dark-only)

| Token | Value |
|-------|-------|
| `--color-bg-primary` | #080808 |
| `--color-bg-surface` | #111111 |
| `--color-bg-hover` | #1A1A1A |
| `--color-text-primary` | #F0F0F0 |
| `--color-text-secondary` | #A0A0A0 |
| `--color-text-tertiary` | #666666 |
| `--color-blue-pale` | #1E3A5F |
| `--color-orange-pale` | #431A04 |
| `--color-cyan-pale` | #083344 |

### halla.ai 전용 (Jeju basalt theme)

| Token | Value | 용도 |
|-------|-------|------|
| `--color-void` | #050a18 | Darkest background |
| `--color-abyss` | #0a1628 | Dark background |
| `--color-deep` | #0f2344 | Heading color (light) |
| `--color-navy` | #1a3a6b | Navy accent |
| `--color-stone` | #edf0f5 | Light surface |
| `--color-chalk` | #f7f8fb | Lightest surface |
| `--color-accent` | #0ea5e9 | Primary (sky blue) |
| `--color-accent-hover` | #0284c7 | Hover state |
| `--color-accent-light` | #e0f2fe | Light accent bg |
| `--color-ember` | #f97316 | Warm accent |
| `--color-emerald` | #10b981 | Success |
| `--color-muted` | #64748b | Muted text |
| `--color-border` | #dce2eb | Border (light) |

### rise.jeju.ai 전용

| Token | Value | 용도 |
|-------|-------|------|
| `--color-primary` | #2f4cb3 | Primary (indigo-ish) |
| `--color-primary-dark` | #1e3470 | Dark primary |
| `--color-primary-light` | #4a6cd4 | Light primary |
| `--color-accent` | #4af2c8 | Accent (teal) |
| `--color-accent-warm` | #f8e42e | Warm (yellow) |
| `--color-accent-coral` | #ff7d54 | Coral |
| `--color-surface-dark` | #0f172a | Dark surface |
| `--color-surface-light` | #f8fafc | Light surface |
| `--color-text-primary` | #0f172a | Text |
| `--color-text-secondary` | #475569 | Secondary text |

## Typography

### Font Stacks

| Project | Display | Body | Code |
|---------|---------|------|------|
| youngjoon-lee.com | `'Space Grotesk', 'Pretendard Variable', system-ui` | 같음 | `'JetBrains Mono', ui-monospace` |
| staixbwlb.com | `'Space Grotesk', 'Pretendard Variable', system-ui` | 같음 | — |
| rise.jeju.ai | `'Pretendard', system-ui` | `'Noto Sans KR', 'Albert Sans', system-ui` | — |
| halla.ai | `'Outfit', 'Pretendard Variable', system-ui` | `'Pretendard Variable', system-ui` | `'JetBrains Mono', 'Fira Code'` |

### Typography Scale

youngjoon-lee.com / staixbwlb.com 공유:

| Token | Value |
|-------|-------|
| `--font-size-display` | `clamp(4rem, 11vw, 10rem)` |
| `--font-size-h1` | `clamp(2.5rem, 6vw, 4.5rem)` |
| `--font-size-h2` | `clamp(2rem, 4vw, 3rem)` |
| `--font-size-h3` | `1.5rem` |
| `--font-size-stat` | `clamp(4.5rem, 12vw, 10rem)` |

rise.jeju.ai:

| Token | Value |
|-------|-------|
| `--text-display-xl` | `clamp(2.5rem, 5vw + 1rem, 4.5rem)` |
| `--text-display-lg` | `clamp(2rem, 3vw + 1rem, 3rem)` |
| `--text-display-md` | `clamp(1.5rem, 2vw + 0.5rem, 2.25rem)` |

### Base Body

- youngjoon-lee.com: `font-size: 1.0625rem` (17px), `line-height: 1.7`
- staixbwlb.com: browser default, `overflow-x: hidden`
- rise.jeju.ai: `line-height: 1.7`, `letter-spacing: -0.01em`
- halla.ai: `line-height: 1.7`, display headings `letter-spacing: -0.02em`

## Spacing

rise.jeju.ai 정의 (가장 체계적):

| Token | Value |
|-------|-------|
| `--spacing-xs` | 0.25rem |
| `--spacing-sm` | 0.5rem |
| `--spacing-md` | 1rem |
| `--spacing-lg` | 1.5rem |
| `--spacing-xl` | 2rem |
| `--spacing-2xl` | 3rem |
| `--spacing-3xl` | 4rem |
| `--section-padding-y` | 5rem |
| `--section-padding-y-lg` | 6rem |

## Border Radius

rise.jeju.ai 정의:

| Token | Value | 용도 |
|-------|-------|------|
| `--radius-sm` | 0.375rem | Small elements |
| `--radius-md` | 0.5rem | Buttons |
| `--radius-lg` | 0.75rem | Cards, pre blocks |
| `--radius-xl` | 1rem | Large cards |
| `--radius-2xl` | 1.5rem | Bento cards |
| `--radius-full` | 9999px | Pills, avatars |

공통 관찰: 버튼 `0.5rem`, 카드 `1rem~1.5rem`, bento `1.25rem~1.5rem`, pill `9999px`

## Shadow

### Light mode (youngjoon-lee.com)

| Token | Value |
|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(15,23,42,0.06)` |
| `--shadow-md` | `0 4px 12px rgba(15,23,42,0.08), 0 1px 3px rgba(15,23,42,0.05)` |
| `--shadow-lg` | `0 8px 24px rgba(15,23,42,0.10), 0 2px 6px rgba(15,23,42,0.06)` |

### Dark mode
- youngjoon-lee.com: `none` (borders provide depth)
- staixbwlb.com: `0 2px 20px rgba(0,0,0,0.5)` base, glow on hover
- halla.ai dark: `0 2px 10px rgba(0,0,0,0.3)` base, glow accents on hover

## Gradient Patterns

### Text gradient (3개 프로젝트 공통)
```css
/* youngjoon-lee.com, staixbwlb.com */
background: linear-gradient(135deg, #2563eb 0%, #22d3ee 50%, #f97316 100%);

/* halla.ai */
background: linear-gradient(135deg, var(--color-accent), #22d3ee, #38bdf8);
```

### Progress bar gradient
```css
background: linear-gradient(90deg, #2563eb, #22d3ee, #f97316);
```

### Section divider
```css
/* Light */
background: linear-gradient(to right, transparent, var(--border), transparent);
/* halla.ai */
background: linear-gradient(90deg, transparent 5%, var(--color-border) 30%, rgba(14,165,233,0.35) 50%, var(--color-border) 70%, transparent 95%);
```

## Easing Tokens

현재 `cubic-bezier(0.16, 1, 0.3, 1)` 이 15+ 곳에서 하드코딩. 토큰화 필요.

```css
/* 공통 easing 토큰 — 모든 프로젝트 적용 권장 */
:root {
  /* Primary — 빠른 시작, 부드러운 착지 (scroll reveal, card hover) */
  --ease-spring: cubic-bezier(0.16, 1, 0.3, 1);
  /* Out — 감속 (일반 transition) */
  --ease-out: cubic-bezier(0.33, 1, 0.68, 1);
  /* In-out — 대칭 (gradient shift, symmetrical motion) */
  --ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);
  /* Linear — 무한 반복 (ribbon, gradient rotate) */
  --ease-linear: linear;
  /* Bounce — 경쾌한 착지 (notification, badge) */
  --ease-bounce: cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

| Token | 값 | 용도 |
|-------|-----|------|
| `--ease-spring` | `cubic-bezier(0.16, 1, 0.3, 1)` | Scroll reveal, card hover, button lift |
| `--ease-out` | `cubic-bezier(0.33, 1, 0.68, 1)` | 일반 transition, fade |
| `--ease-in-out` | `cubic-bezier(0.65, 0, 0.35, 1)` | Gradient shift, symmetric motion |
| `--ease-linear` | `linear` | Ribbon scroll, gradient rotate, continuous |
| `--ease-bounce` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Notification pop, badge animation |

## Duration Tokens

```css
:root {
  --duration-instant: 100ms;   /* 즉각 반응 (active state) */
  --duration-fast: 150ms;      /* 빠른 전환 (hover color) */
  --duration-normal: 300ms;    /* 일반 전환 (hover transform, border) */
  --duration-slow: 500ms;      /* 느린 전환 (modal enter, accordion) */
  --duration-reveal: 800ms;    /* Scroll reveal, hero enter */
  --duration-gradient: 12s;    /* Hero gradient rotation */
  --duration-ribbon: 30s;      /* Ribbon scroll (infinite) */
}
```

| Token | 값 | 용도 |
|-------|-----|------|
| `--duration-instant` | 100ms | Active state, press feedback |
| `--duration-fast` | 150ms | Hover color change, border-color |
| `--duration-normal` | 300ms | Hover transform, general transition |
| `--duration-slow` | 500ms | Modal/accordion enter/exit |
| `--duration-reveal` | 800ms | Scroll reveal, hero stagger |
| `--duration-gradient` | 12s | Hero gradient rotation |
| `--duration-ribbon` | 30s | Ribbon/marquee scroll |

## Z-index Scale

```css
:root {
  --z-base: 0;        /* 기본 콘텐츠 */
  --z-dropdown: 100;   /* Dropdown, popover */
  --z-sticky: 200;     /* Sticky header */
  --z-overlay: 300;    /* Overlay, backdrop */
  --z-modal: 400;      /* Modal, dialog */
  --z-toast: 500;      /* Toast notification */
  --z-tooltip: 600;    /* Tooltip */
  --z-grain: 9999;     /* Film grain overlay (항상 최상위) */
}
```

프로젝트별 현황:
- youngjoon-lee.com: grain `z-index: 9999` 하드코딩
- staixbwlb.com: 하드코딩 (정리 필요)
- halla.ai: header `z-50` (Tailwind utility, OK)
- rise.jeju.ai: `--z-header: 100` 등 일부 토큰 있음

## 공통 Spacing Scale (권장)

rise.jeju.ai에서 추출한 spacing scale을 공통 권장 기준으로 승격.

```css
/* 모든 프로젝트 적용 권장 spacing scale */
:root {
  --spacing-xs: 0.25rem;    /* 4px — icon gap, inline padding */
  --spacing-sm: 0.5rem;     /* 8px — tight gap, input padding */
  --spacing-md: 1rem;       /* 16px — standard gap, card padding */
  --spacing-lg: 1.5rem;     /* 24px — section inner gap */
  --spacing-xl: 2rem;       /* 32px — section gap */
  --spacing-2xl: 3rem;      /* 48px — large gap */
  --spacing-3xl: 4rem;      /* 64px — section top/bottom */
  --section-padding-y: 5rem;     /* 80px — section vertical padding */
  --section-padding-y-lg: 6rem;  /* 96px — hero section padding */
}
```

Note: Tailwind 유틸리티(`p-4`, `gap-6` 등)와 병용. CSS custom property는 복합 계산이나 일관성 필요 시 사용.

## oklch() Color Alternatives

기존 hex 토큰의 oklch 등가값. 새 프로젝트에서 oklch 채택 시 참고.

```css
/* hex → oklch 변환 (주요 공통 토큰) */
/*
  --color-blue:     #2563eb → oklch(0.55 0.2 260)
  --color-cyan:     #22d3ee → oklch(0.78 0.13 200)
  --color-orange:   #f97316 → oklch(0.72 0.19 55)
  --color-emerald:  #10b981 → oklch(0.68 0.15 165)
*/
```

oklch 장점:
- Lightness 조절이 직관적 (`oklch(0.55 ...)` → `oklch(0.7 ...)` 밝게)
- Chroma 조절로 채도 통제 (0 = 무채색, 0.3+ = 고채도)
- Dark mode 팔레트 생성이 규칙적 (lightness만 변경)

`color-mix()` 패턴 (oklch와 함께 사용):
```css
/* 토큰 기반 투명도 조절 */
.hover-bg {
  background: color-mix(in oklch, var(--color-accent) 10%, transparent);
}
/* 토큰 기반 밝기 조절 */
.lighter {
  color: color-mix(in oklch, var(--color-accent) 80%, white);
}
.darker {
  color: color-mix(in oklch, var(--color-accent) 80%, black);
}
```

## Transition Shorthand Tokens

자주 쓰는 transition 조합을 토큰화.

```css
:root {
  --transition-colors: color var(--duration-fast) var(--ease-out),
                       background-color var(--duration-fast) var(--ease-out),
                       border-color var(--duration-fast) var(--ease-out);
  --transition-transform: transform var(--duration-normal) var(--ease-spring);
  --transition-shadow: box-shadow var(--duration-normal) var(--ease-out);
  --transition-opacity: opacity var(--duration-normal) var(--ease-out);
  --transition-all: all var(--duration-normal) var(--ease-spring);
}
```

사용:
```css
.card {
  transition: var(--transition-colors), var(--transition-transform), var(--transition-shadow);
}
/* 또는 Tailwind 유틸리티: transition-all duration-300 */
```
