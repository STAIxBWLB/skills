---
name: design-init
description: "새 프로젝트 초기 디자인 방향 설정 + scaffolding. 5단계 선호도 인터뷰로 맞춤 설정. Astro + Tailwind v4 기반으로 global.css, fonts.css, 기본 layout 생성. 트리거: 새 프로젝트, 프로젝트 초기화, design init, new project design, 디자인 세팅, 디자인 초기화, 프로젝트 셋업, scaffold design, 디자인 스캐폴딩"
---

# Design Init 스킬

새 프로젝트의 초기 디자인 방향을 설정하고, 기본 CSS 파일과 레이아웃을 생성한다.
기존 5개 프로젝트의 디자인 언어를 기반으로 일관된 시작점을 제공.

## 파라미터

### INTENSITY (1-5)

디자인의 대담함 수준.

| Level | 설명 | 예시 |
|-------|------|------|
| 1 | **Conservative** — 최소한의 스타일링 | Starlight docs, 기본 문서 사이트 |
| 2 | **Clean** — 깔끔하고 전문적 | 기업 사이트, 안내 페이지 |
| 3 | **Balanced** — 적절한 시각 효과 | rise.jeju.ai 수준 |
| 4 | **Bold** — 강한 시각적 인상 | halla.ai 수준 |
| 5 | **Creative** — 실험적, 인터랙티브 | staixbwlb.com, youngjoon-lee.com 수준 |

### DARKNESS (light / dark / both)

| Option | 설명 |
|--------|------|
| `light` | Light mode only (rise.jeju.ai 패턴) |
| `dark` | Dark mode only (staixbwlb.com 패턴) |
| `both` | Light + dark toggle (youngjoon-lee.com, halla.ai 패턴) |

### TYPE (docs / landing / portfolio / app)

| Type | 특성 |
|------|------|
| `docs` | 가독성 최우선, minimal effects, Starlight 호환 |
| `landing` | Hero section, CTA, scroll reveal, 1-page focus |
| `portfolio` | Bento grid, project showcase, creative effects |
| `app` | Sidebar/header layout, form elements, data display |

## 워크플로우

### 1. 선호도 인터뷰 (5단계)

파라미터를 직접 지정하지 않은 경우, 인터랙티브 인터뷰로 수집한다.
각 단계에서 선택지를 제시하고 사용자 응답에 따라 다음 단계를 진행.
상세 매핑은 `references/preference-guide.md` 참조.

**Step 1 — 사이트 유형**: "어떤 종류의 사이트인가요?"
- 문서/교육 사이트 → TYPE=docs
- 랜딩 페이지 → TYPE=landing
- 포트폴리오/쇼케이스 → TYPE=portfolio
- 웹 앱 → TYPE=app
- 기관/대학 공식 → TYPE=landing (INTENSITY 3 기본)

**Step 2 — 참조 프로젝트**: "참고할 기존 프로젝트가 있나요?"
- youngjoon-lee.com 스타일 (포트폴리오, 다크+라이트, creative)
- staixbwlb.com 스타일 (bold, 다크, bento)
- halla.ai 스타일 (기관, 다크+라이트, 정돈된)
- rise.jeju.ai 스타일 (깔끔, 라이트, 정보 중심)
- 새로운 방향 → Step 3로 진행

참조 프로젝트 선택 시: 해당 프로젝트의 global.css를 베이스로 변형하고, Step 4(색상)와 Step 5(접근성)만 추가 확인 후 scaffold 생성.

**Step 3 — 분위기** (새로운 방향 선택 시만): "분위기는?"
- 미니멀/클린 → INTENSITY 1-2
- 전문적/신뢰감 → INTENSITY 3
- 모던/세련된 → INTENSITY 4
- 대담/실험적 → INTENSITY 5
- 추가: 라이트/다크/둘 다 → DARKNESS 결정

**Step 4 — 색상**: "주요 색상은?"
- Blue-Cyan (default) — 기존 프로젝트 공통
- Jeju — halla.ai 바다/현무암 테마
- Indigo — rise.jeju.ai 전문적 느낌
- 직접 지정 — primary hex + accent hex 입력 → @theme 토큰 자동 생성 + light/dark 팔레트 파생

**Step 5 — 접근성**: "한국어 사이트인가요? 공공기관 접근성 필요?"
- 한국어 여부 → `:lang(ko)` 설정
- 공공기관 여부 → WCAG AA + KWCAG 추가 규칙 적용 (contrast AAA, target size 44px, 키보드 전용 nav 등)

### 직접 파라미터 지정

인터뷰 대신 직접 지정도 가능:
- 프로젝트 이름
- INTENSITY, DARKNESS, TYPE 파라미터
- 주요 색상 (기본: blue/cyan/orange 계열 유지)
- 한국어 사이트 여부

### 2. 파일 생성

생성하는 파일:

```
src/styles/
├── global.css      # @import, @theme, design tokens, base styles
└── fonts.css       # @font-face declarations (필요 시)
src/layouts/
└── Base.astro      # 기본 레이아웃 (head, body, slot)
```

### 3. global.css 구조

```css
/* 1. Tailwind import */
@import "tailwindcss";
@import "./fonts.css";  /* 커스텀 폰트 시 */

/* 2. Plugin */
@plugin "@tailwindcss/typography";

/* 3. Dark mode variant (DARKNESS=both 시) */
@custom-variant dark (&:where(.dark, .dark *));

/* 4. Theme tokens (신규 프로젝트: @theme extend 권장) */
@theme extend {
  --font-sans: ...;
  --font-display: ...;
  --font-mono: ...;
  --color-*: ...;
}

/* 5. Design tokens (CSS custom properties) */
:root { ... }
.dark { ... }  /* DARKNESS=both 시 */

/* 6. 한글 설정 */
:lang(ko) {
  word-break: keep-all;
  overflow-wrap: break-word;
}

/* 7. Base styles */
html { scroll-behavior: smooth; }
body { ... }

/* 8. Utilities */
.text-gradient { ... }
.section-divider { ... }

/* 9. Accessibility */
.skip-link { ... }
:focus-visible { ... }
::selection { ... }

/* 10. Reduced motion */
@media (prefers-reduced-motion: reduce) { ... }
```

## INTENSITY별 포함 요소

| 요소 | 1 | 2 | 3 | 4 | 5 |
|------|---|---|---|---|---|
| Base tokens (color, font, easing, duration) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Korean typography | ✓ | ✓ | ✓ | ✓ | ✓ |
| Skip link | ✓ | ✓ | ✓ | ✓ | ✓ |
| Focus visible | ✓ | ✓ | ✓ | ✓ | ✓ |
| Reduced motion | ✓ | ✓ | ✓ | ✓ | ✓ |
| Custom scrollbar | | ✓ | ✓ | ✓ | ✓ |
| Selection color | | ✓ | ✓ | ✓ | ✓ |
| CSS nesting | | | ✓ | ✓ | ✓ |
| Text gradient (`@utility`) | | | ✓ | ✓ | ✓ |
| Section divider | | | ✓ | ✓ | ✓ |
| Scroll reveal | | | ✓ | ✓ | ✓ |
| btn-glow / btn-solid | | | | ✓ | ✓ |
| glow-border cards | | | | ✓ | ✓ |
| Header blur | | | | ✓ | ✓ |
| `@starting-style` entry animations | | | | ✓ | ✓ |
| Container queries (카드 반응형) | | | | ✓ | ✓ |
| Film grain | | | | | ✓ |
| Hero mesh gradient | | | | | ✓ |
| Bento grid | | | | | ✓ |
| Ribbon scroll | | | | | ✓ |
| Scroll-driven animations | | | | | ✓ |
| View Transitions (Astro) | | | | | ✓ |
| 3D tilt | | | | | ✓ |
| Neon text | | | | | ✓ |

## Color Presets

기본 색상 프리셋 (사용자가 다른 색상 지정 가능):

### Preset: Blue-Cyan (default)
- Primary: #2563eb → Cyan: #22d3ee → Orange: #f97316

### Preset: Jeju (halla.ai 스타일)
- Accent: #0ea5e9 → Cyan: #22d3ee → Ember: #f97316
- Depth: void #050a18, abyss #0a1628, deep #0f2344

### Preset: Indigo (rise.jeju.ai 스타일)
- Primary: #2f4cb3 → Accent: #4af2c8 → Warm: #f8e42e

## 출력 예시

사용자: "새 프로젝트 디자인 세팅해줘. INTENSITY 4, DARKNESS both, TYPE landing"

→ `global.css` (btn-glow, glow-border, scroll reveal, header blur 포함)
→ `fonts.css` (Pretendard + Space Grotesk @font-face)
→ `Base.astro` (dark mode toggle, skip link, grain overlay, header blur)
