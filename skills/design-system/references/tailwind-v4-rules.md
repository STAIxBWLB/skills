# Tailwind v4 Rules Reference

5개 프로젝트에서 사용하는 Tailwind CSS v4 규칙 정리.

## 핵심: @theme inline 방식

Tailwind v4에서는 `tailwind.config.js` 대신 CSS에서 직접 설정.

```css
@import "tailwindcss";

@theme {
  --font-sans: 'Space Grotesk', 'Pretendard Variable', system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
  --color-accent-blue: #2563eb;
  --color-accent-cyan: #22d3ee;
}
```

### @theme 규칙
- `@theme {}` 안에 정의한 CSS custom properties는 Tailwind 유틸리티에서 자동 사용 가능
- `--font-sans` → `font-sans` 클래스
- `--color-*` → `text-*`, `bg-*`, `border-*` 클래스
- `--font-size-*` → `text-*` 클래스

### @theme vs :root
- `@theme {}`: Tailwind 유틸리티 생성에 참여 (e.g., `bg-blue` 자동 생성)
- `:root {}`: 일반 CSS custom property (Tailwind utility 미생성, `var()` 직접 참조만)
- 혼용 가능: `@theme`에 핵심 토큰, `:root`에 세부 토큰

## Dark Mode

```css
@custom-variant dark (&:where(.dark, .dark *));
```

- HTML `<html class="dark">` 토글 방식
- Tailwind `dark:` 접두사 사용 가능
- 또는 `.dark {}` CSS 블록에서 직접 재정의

## Plugin Loading

```css
@plugin "@tailwindcss/typography";
```

- `@plugin` directive로 플러그인 로드
- `require()` / `import` 대신 CSS에서 직접 선언

## 프로젝트별 @theme 사용 패턴

### youngjoon-lee.com
```css
@theme {
  --font-sans: 'Space Grotesk', 'Pretendard Variable', system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
  --color-accent-blue: #2563eb;
  --color-accent-cyan: #22d3ee;
  --color-accent-orange: #f97316;
}
/* + :root에 상세 디자인 토큰 */
```

### staixbwlb.com
```css
@theme {
  /* 전체 토큰을 @theme에 정의 */
  --color-bg-primary: #080808;
  --color-bg-surface: #111111;
  --color-text-primary: #F0F0F0;
  --font-size-display: clamp(4rem, 11vw, 10rem);
  --font-sans: 'Space Grotesk', 'Pretendard Variable', system-ui, sans-serif;
}
```

### rise.jeju.ai
```css
@theme {
  /* font만 @theme에 */
  --font-display: 'Pretendard', system-ui, sans-serif;
  --font-sans: 'Noto Sans KR', 'Albert Sans', system-ui, sans-serif;
}
/* 색상/spacing은 :root CSS variables */
```

### halla.ai
```css
@theme {
  /* 색상 + 폰트 모두 @theme에 */
  --color-void: #050a18;
  --color-accent: #0ea5e9;
  --font-sans: 'Pretendard Variable', system-ui, sans-serif;
  --font-display: 'Outfit', 'Pretendard Variable', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;
}
```

## 주의사항

1. **@theme에 정의한 property는 Tailwind 유틸리티 네임스페이스에 자동 등록됨**
   - `--color-accent` → `bg-accent`, `text-accent` 등
   - 의도치 않은 클래스 충돌 주의

2. **CSS import 순서 중요**
   - `@import "tailwindcss"` 반드시 최상단
   - `@theme`은 그 뒤에
   - `@plugin`은 `@import` 뒤에

3. **`@layer` 사용**
   - base: 리셋, 전역 스타일
   - components: 재사용 컴포넌트
   - utilities: 커스텀 유틸리티
   - halla.ai에서 `@layer base {}` 사용 예시 있음

4. **Font loading**
   - `@font-face`는 `@theme` 밖에 정의
   - `font-display: swap` 필수
   - self-hosted woff2 권장 (성능)

---

## @theme 모드: replace vs extend

```css
/* Replace (기본) — 기존 Tailwind 기본값을 완전히 대체 */
@theme {
  --color-primary: #2563eb;
  /* Tailwind 기본 색상(slate, gray 등)이 모두 제거됨 */
}

/* Extend — 기존 기본값 유지하면서 토큰 추가 */
@theme extend {
  --color-brand: #2563eb;
  /* Tailwind 기본값은 그대로, brand-* 유틸리티만 추가 */
}
```

- koica-tiu는 `global.css:52`에서 `@theme extend` 사용 중
- **신규 프로젝트 권장**: `@theme extend` — Tailwind 기본값(slate, gray, blue 등)을 보존하면서 커스텀 토큰 추가
- 기존 youngjoon, staixbwlb, rise, halla는 `@theme` (replace 모드) 사용 중

---

## @utility — 커스텀 유틸리티

```css
/* @layer utilities 대신 @utility 사용 — variant와 함께 작동 */
@utility text-gradient {
  background: linear-gradient(135deg, var(--color-blue), var(--color-cyan));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

@utility card-glass {
  background: rgb(from var(--color-surface) r g b / 0.6);
  backdrop-filter: blur(12px);
  border: 1px solid rgb(from var(--color-border) r g b / 0.3);
}
```

```html
<!-- variant와 함께 작동 (hover:, dark:, group-hover: 등) -->
<h1 class="text-gradient hover:text-gradient">제목</h1>
<div class="card-glass dark:card-glass">카드</div>
```

- 현재 global.css의 `.text-gradient` 클래스는 `@utility`로 마이그레이션하면 variant 지원 가능
- `@layer utilities {}`보다 `@utility` 선호 — Tailwind v4 네이티브 방식

---

## @variant — 커스텀 variant

```css
/* 복합 선택자를 variant로 추상화 */
@variant hovered (&:hover, &:focus-visible);
@variant theme-dark (&:where(.dark, .dark *));
@variant motion-safe (@media (prefers-reduced-motion: no-preference));
```

```html
<!-- 사용 -->
<button class="hovered:opacity-100 hovered:scale-105">버튼</button>
<div class="theme-dark:bg-surface theme-dark:text-white">컨텐츠</div>
<div class="motion-safe:transition-transform">애니메이션</div>
```

- `@custom-variant`(v4 초기)와 동일 기능, `@variant`가 최신 문법
- `@custom-variant dark`와 `@variant hovered` 혼용 가능

---

## @source — 클래스 감지 경로

```css
/* Tailwind가 스캔할 소스 경로 명시 */
@source "../components/**/*.astro";
@source "../content/**/*.md";
@source "../pages/**/*.astro";

/* 동적 클래스 — 런타임에 조합되는 클래스명 명시 */
@source inline("bg-blue-500 text-white p-4 rounded-lg");
@source inline("grid-cols-1 grid-cols-2 grid-cols-3 grid-cols-4");
```

- Astro 프로젝트는 기본적으로 `.astro`, `.ts`, `.js` 스캔
- CMS 콘텐츠나 동적으로 생성되는 클래스는 `@source inline()`으로 명시 필요
- `safelist` 대체 문법

---

## @reference — CSS 미출력 임포트

```css
/* 유틸리티 이름만 참조, 실제 CSS는 출력하지 않음 */
@reference "tailwindcss";

/* 토큰 파일 타입 참조만 (CSS 미출력) */
@reference "./tokens.css";
```

- 컴포넌트 CSS에서 Tailwind 유틸리티를 `@apply`로 사용할 때 유용
- `@import "tailwindcss"` 대신 쓰면 중복 출력 방지
- 예: Astro 컴포넌트 `<style>` 블록 내에서 `@apply` 사용 시

---

## has-* / not-* / in-* variants

### `:has()` — 부모 조건부 스타일링

```html
<!-- img 자식이 있으면 2열 그리드 -->
<div class="has-[img]:grid-cols-2">...</div>

<!-- checked input이 있으면 배경색 변경 -->
<label class="has-[input:checked]:bg-blue-100 has-[input:checked]:border-blue-500">
  <input type="checkbox" />
  체크박스 레이블
</label>

<!-- 비어있지 않은 경우만 표시 -->
<div class="has-[*]:block hidden">콘텐츠가 있을 때만</div>
```

### `:not()` — 부정 variant

```html
<!-- 마지막 요소 제외하고 하단 border -->
<li class="not-last:border-b not-last:pb-2">리스트 아이템</li>

<!-- hover 상태가 아닐 때 opacity -->
<div class="not-hover:opacity-60 transition-opacity">카드</div>

<!-- 첫 번째 제외 -->
<div class="not-first:mt-4">섹션</div>
```

### `:is()` 내부 컨텍스트 — `in-*`

```html
<!-- .dark 컨텍스트 안에 있을 때 -->
<span class="in-[.dark]:text-white in-[.dark]:bg-transparent">텍스트</span>

<!-- 특정 컨테이너 안에서 다른 스타일 -->
<div class="in-[.sidebar]:text-sm in-[.main]:text-base">적응형 텍스트</div>
```

---

## group-* / peer-* 개선

### Named groups — 중첩 group 구분

```html
<!-- 이름 있는 group: group/{name} -->
<div class="group/card rounded-lg border p-4">
  <div class="group/header flex items-center">
    <h3 class="group-hover/card:text-blue-500">카드 제목</h3>
    <span class="group-hover/header:rotate-180 transition-transform">▼</span>
  </div>
  <p class="opacity-0 group-hover/card:opacity-100 transition-opacity">설명</p>
</div>
```

### has-* with group

```html
<!-- form 안에 checked input이 있으면 submit 버튼 활성화 -->
<form class="group/form">
  <input type="checkbox" class="peer" />
  <button class="opacity-50 group-has-[input:checked]/form:opacity-100">
    제출
  </button>
</form>
```

### peer with has

```html
<!-- peer의 자식 상태에 따라 형제 요소 스타일 변경 -->
<div class="peer">
  <input type="text" />
</div>
<p class="hidden peer-has-[:focus]:block text-sm text-blue-500">
  입력 중...
</p>
```

---

## Container Queries

```css
/* @theme에 container 사이즈 정의 */
@theme extend {
  --container-3xs: 16rem;  /* 256px */
  --container-2xs: 18rem;  /* 288px */
  --container-xs: 20rem;   /* 320px */
}
```

```html
<!-- @container 선언 -->
<div class="@container">
  <!-- 컨테이너 너비에 따라 반응 (뷰포트 아닌 부모 기준) -->
  <div class="grid grid-cols-1 @sm:grid-cols-2 @lg:grid-cols-3 gap-4">
    <div class="card">...</div>
  </div>
</div>

<!-- Named container -->
<aside class="@container/sidebar">
  <nav class="@lg/sidebar:flex-row flex-col">...</nav>
</aside>
```

```css
/* CSS에서 직접 */
@container (min-width: 400px) {
  .card {
    grid-template-columns: 1fr 1fr;
  }
}
```

- 카드, 위젯, 사이드바 등 컴포넌트 레벨 반응형에 적합
- 뷰포트 기반 media query 대체가 아닌 보완 — 동일 컴포넌트를 다양한 레이아웃에서 재사용할 때 유용

---

## CSS Nesting (네이티브)

```css
/* Tailwind v4는 네이티브 CSS nesting 완전 지원 */
/* koica-tiu components.css에서 이미 사용 중 */
.card {
  border: 1px solid var(--color-border);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(135deg, transparent, rgb(from var(--color-accent) r g b / 0.05));
    opacity: 0;
    transition: opacity 0.3s ease;
  }

  &:hover {
    border-color: var(--color-accent);
    transform: translateY(-2px);

    &::before {
      opacity: 1;
    }
  }

  /* 부모 컨텍스트 (.dark 안에 있을 때) */
  .dark & {
    border-color: rgba(255, 255, 255, 0.08);
    background: rgba(255, 255, 255, 0.03);
  }
}
```

- `&` 필수 — 없으면 하위 선택자 아닌 형제로 해석됨
- 모든 신규 CSS에 nesting 사용 권장 (가독성 + 유지보수)
- `.dark &` 패턴: 부모에 `.dark` 클래스가 있을 때 적용

---

## Relative Color Syntax

```css
/* koica-tiu에서 20+ 곳 실사용 중 — rgba() 하드코딩 대체 */

/* 기존 방식 (하드코딩, 토큰 변경 시 일일이 수정 필요) */
/* border-color: rgba(37, 99, 235, 0.4); */
/* box-shadow: 0 0 20px rgba(37, 99, 235, 0.08); */

/* 신규 방식 (토큰 기반, 투명도만 조절) */
.card-hover {
  border-color: rgb(from var(--color-accent) r g b / 0.4);
  box-shadow: 0 0 20px rgb(from var(--color-accent) r g b / 0.08);
  background: rgb(from var(--color-surface) r g b / 0.6);
}

/* oklch 색상에서도 동일하게 */
.badge {
  background: oklch(from var(--color-primary) l c h / 0.15);
  border: 1px solid oklch(from var(--color-primary) l c h / 0.4);
}
```

- 토큰 기반 색상에서 투명도만 변경할 때 필수
- 하드코딩 `rgba()` 제거의 핵심 패턴
- 브라우저 지원: Chrome 119+, Safari 16.4+, Firefox 128+

---

## @property (CSS Houdini)

```css
/* 커스텀 property를 @keyframes에서 animate 가능하게 함 */
/* 프로젝트에서 이미 사용 중: hero gradient angle animation */

@property --gradient-angle {
  syntax: '<angle>';
  initial-value: 0deg;
  inherits: false;
}

@property --gradient-pos {
  syntax: '<percentage>';
  initial-value: 50%;
  inherits: false;
}

@property --shimmer-pos {
  syntax: '<percentage>';
  initial-value: -100%;
  inherits: false;
}

/* @property 없이는 CSS custom property를 직접 animate 불가 */
.hero-gradient {
  background: conic-gradient(
    from var(--gradient-angle),
    var(--color-accent),
    var(--color-primary),
    var(--color-accent)
  );
  animation: spin-gradient 8s linear infinite;
}

@keyframes spin-gradient {
  to { --gradient-angle: 360deg; }
}
```

---

## 모던 CSS 통합 패턴

### `color-mix()` — 동적 색상 블렌딩

```css
/* oklch 색 공간에서 블렌딩 (지각적으로 균일) */
.surface-hover {
  background: color-mix(in oklch, var(--color-accent) 10%, transparent);
}

.text-dimmed {
  color: color-mix(in srgb, var(--color-text-primary) 60%, transparent);
}

/* 두 토큰 색상 중간값 */
.gradient-mid {
  background: color-mix(in oklch, var(--color-primary) 50%, var(--color-secondary));
}
```

### `oklch()` — 지각적 균일 색상

```css
@theme extend {
  /* oklch(lightness chroma hue) */
  /* lightness: 0-1, chroma: 0-0.37, hue: 0-360 */
  --color-primary: oklch(0.55 0.2 260);
  --color-primary-light: oklch(0.7 0.15 260);   /* lightness만 올림 */
  --color-primary-dark: oklch(0.4 0.2 260);     /* lightness만 내림 */
  --color-primary-muted: oklch(0.55 0.08 260);  /* chroma만 낮춤 */
}
/* hex보다 직관적: 명도/채도/색상이 독립적으로 조절됨 */
```

### `light-dark()` — 라이트/다크 한줄 정의

```css
:root { color-scheme: light dark; }

.element {
  color: light-dark(#0f172a, #f0f0f0);
  background: light-dark(#f8fafc, #080808);
  border-color: light-dark(#e2e8f0, rgba(255, 255, 255, 0.08));
}

/* @custom-variant dark 방식과 병용 가능 */
/* dark: 접두사 없이 한줄로 처리할 때 유용 */
```

### `@starting-style` — 엔트리 애니메이션

```css
/* display:none → visible 전환 시 진입 애니메이션 */
dialog[open] {
  opacity: 1;
  transform: scale(1);
  transition: opacity 0.3s ease, transform 0.3s ease, display 0.3s allow-discrete;

  @starting-style {
    opacity: 0;
    transform: scale(0.95);
  }
}

/* Popover 진입 */
[popover]:popover-open {
  opacity: 1;
  translate: 0 0;
  transition: opacity 0.2s, translate 0.2s, display 0.2s allow-discrete,
              overlay 0.2s allow-discrete;

  @starting-style {
    opacity: 0;
    translate: 0 -8px;
  }
}
```

### Scroll-driven Animations

```css
/* rise.jeju.ai utilities.css에서 실사용 중 */
/* IntersectionObserver 없이 CSS-only scroll 연동 */

.progress-bar {
  animation: grow-width linear;
  animation-timeline: scroll(root);
}

@keyframes grow-width {
  from { width: 0%; }
  to { width: 100%; }
}

/* 요소 자체의 스크롤 위치 기반 */
.fade-in-on-scroll {
  animation: fade-up linear both;
  animation-timeline: view();
  animation-range: entry 0% entry 30%;
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Popover API

```css
[popover] {
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: 1rem;
  box-shadow: 0 8px 32px rgb(0 0 0 / 0.12);

  &::backdrop {
    background: rgb(0 0 0 / 0.3);
    backdrop-filter: blur(2px);
  }
}
```

```html
<!-- JS 없이 토글 -->
<button popovertarget="menu">메뉴 열기</button>
<div popover id="menu">
  <nav>...</nav>
</div>
```

---

## 프로젝트별 모던 CSS 채택 현황

| 기능 | youngjoon | staixbwlb | rise | halla | koica-tiu |
|------|:---------:|:---------:|:----:|:-----:|:---------:|
| `@theme extend` | ✗ | ✗ | ✗ | ✗ | ✓ |
| CSS nesting | ✗ | ✗ | ✗ | ✗ | ✓ |
| Relative color syntax | ✗ | ✗ | ✗ | ✗ | ✓ (20+) |
| Scroll-driven animations | ✗ | ✗ | ✓ | ✗ | ✗ |
| `text-wrap: pretty` | ✗ | ✗ | ✗ | ✗ | ✓ |
| `@property` (Houdini) | ✗ | ✗ | ✗ | ✗ | ✓ |
| Container queries | ✗ | ✗ | ✗ | ✗ | ✗ |
| `@starting-style` | ✗ | ✗ | ✗ | ✗ | ✗ |
| `color-mix()` | ✗ | ✗ | ✗ | ✗ | ✗ |
| `oklch()` 색상 | ✗ | ✗ | ✗ | ✗ | ✗ |
| `light-dark()` | ✗ | ✗ | ✗ | ✗ | ✗ |
| Popover API | ✗ | ✗ | ✗ | ✗ | ✗ |

**koica-tiu가 선도 프로젝트** 역할. 다른 프로젝트는 점진 채택 권장.

### 마이그레이션 우선순위

1. **즉시 적용 가능** (기존 코드 영향 없음): `@theme extend`, relative color syntax, CSS nesting
2. **컴포넌트 신규 작성 시**: `@utility`, container queries, `@starting-style`
3. **점진 교체**: `rgba()` 하드코딩 → relative color, `@layer utilities` → `@utility`
4. **탐색 단계**: `oklch()`, `color-mix()`, `light-dark()`, Popover API
