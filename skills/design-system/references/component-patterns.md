# Component Patterns Reference

프로젝트 간 공통 컴포넌트 패턴 정리.

## Button

### btn-glow (ghost button with glow hover)

모든 프로젝트에서 공유. 투명 배경 + 보더 + hover 시 glow.

```css
.btn-glow {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 2rem;
  background: transparent;
  border: 1.5px solid var(--border);
  border-radius: 0.5rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.3s ease;
}
.btn-glow::before {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(
    135deg,
    rgba(37, 99, 235, 0.1),
    rgba(34, 211, 238, 0.07)
  );
  opacity: 0;
  transition: opacity 0.3s ease;
}
.btn-glow:hover {
  border-color: rgba(37, 99, 235, 0.7);
  box-shadow: 0 4px 20px rgba(37, 99, 235, 0.2);
  transform: translateY(-1px);
}
.btn-glow:hover::before {
  opacity: 1;
}
```

### btn-solid (gradient solid button)

```css
.btn-solid {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 2rem;
  background: linear-gradient(135deg, #2563eb, #22d3ee);
  border-radius: 0.5rem;
  color: #f0f0f0;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
}
.btn-solid:hover {
  opacity: 0.9;
  transform: translateY(-2px);
  box-shadow: 0 12px 30px rgba(37, 99, 235, 0.4);
}
```

halla.ai 변형: `btn-solid-gradient` — `::before`로 reverse gradient overlay

## Card

### glow-border (기본 카드)

```css
.glow-border {
  border: 1px solid var(--border);
  box-shadow: var(--shadow-sm);
  transition:
    border-color 0.3s,
    box-shadow 0.3s;
}
.glow-border:hover {
  border-color: rgba(37, 99, 235, 0.4);
  box-shadow:
    var(--shadow-md),
    0 0 20px rgba(37, 99, 235, 0.08);
}
```

### card-tilt (3D hover effect)

```css
.card-tilt {
  transform-style: preserve-3d;
  transition: transform 0.3s ease;
}
.card-tilt:hover {
  transform: perspective(800px) rotateX(3deg) rotateY(-3deg);
}
```

### Bento Card (staixbwlb.com)

```css
.bento-card {
  border-radius: 1.5rem;
  overflow: hidden;
  position: relative;
  transition:
    transform 0.4s cubic-bezier(0.16, 1, 0.3, 1),
    box-shadow 0.4s ease;
}
.bento-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 30px 60px rgba(0, 0, 0, 0.5);
}
```

Color variants: `.bento-dark`, `.bento-blue`, `.bento-purple`, `.bento-gold`, `.bento-cyan`

### Card system (halla.ai — 3종)

- `.card` — Base card with shimmer hover effect
- `.card-flat` — Flat card for secondary content
- `.card-bento` — Bento card with gradient bar + glow

공통 특징: `::before`/`::after` pseudo-elements로 hover 효과, dark mode 별도 스타일

## Hero

### hero-gradient (mesh gradient background)

youngjoon-lee.com / staixbwlb.com: cursor-reactive mesh gradient

```css
.hero-gradient {
  background:
    radial-gradient(
      ellipse at var(--cursor-x, 50%) var(--cursor-y, 50%),
      rgba(37, 99, 235, 0.18) 0%,
      transparent 60%
    ),
    conic-gradient(
      from var(--gradient-angle) at var(--gradient-pos) 50%,
      rgba(37, 99, 235, 0.12),
      rgba(34, 211, 238, 0.08),
      rgba(249, 115, 22, 0.06),
      rgba(37, 99, 235, 0.12)
    ),
    #080808;
  animation:
    rotate-gradient 12s linear infinite,
    shift-gradient 16s ease-in-out infinite;
}
```

halla.ai: `hero-gradient-mesh` with `::before`/`::after` blobs

### Kinetic typography (youngjoon-lee.com)

```css
.hero-line {
  display: block;
  opacity: 0;
  transform: translateY(40px);
  animation: line-enter 0.9s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
```

## Header

### Sticky blur header

```css
.header-blur {
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  background: color-mix(in srgb, var(--bg-primary) 90%, transparent);
}
```

halla.ai: transparent → solid transition (`header-transparent` / `header-solid`)

## Tag / Pill

```css
.tag-pill {
  display: inline-flex;
  align-items: center;
  padding: 0.375rem 1rem;
  border-radius: 9999px;
  font-size: 0.7rem; /* 또는 0.875rem */
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
```

## Section Divider

```css
.section-divider {
  height: 1px;
  border: none;
  background: linear-gradient(
    to right,
    transparent,
    var(--border),
    transparent
  );
}
```

## Stat Counter

스탯 숫자 3열 가로 배치. 수료생 수, 만족도, 협력 기업 수 등 신뢰 시그널 표시.

```css
.stat-counter {
  display: flex;
  justify-content: center;
  gap: 4rem;
  padding: 2rem 0;
}
.stat-counter__number {
  font-size: clamp(3rem, 8vw, 5rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1;
  text-align: center;
}
.stat-counter__label {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-muted, #64748b);
  margin-top: 0.5rem;
  text-align: center;
}
@media (max-width: 640px) {
  .stat-counter {
    gap: 2rem;
  }
}
```

적용: rise.jeju.ai (참여 학생 수), halla.ai (취업률), EdTech 랜딩 전반

## Atmospheric Hero

상단에서 확산되는 radial gradient로 공간감 부여. cursor-reactive mesh보다 가볍고 자연스러움.

```css
.atmospheric-hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: hidden;
}
.atmospheric-hero::before {
  content: "";
  position: absolute;
  top: -20%;
  left: 50%;
  translate: -50% 0;
  width: 140%;
  height: 70%;
  background: radial-gradient(
    ellipse at 50% 30%,
    rgba(var(--accent-rgb, 59, 130, 246), 0.15) 0%,
    rgba(var(--accent-secondary-rgb, 6, 182, 212), 0.08) 30%,
    transparent 70%
  );
  filter: blur(60px);
  pointer-events: none;
}
```

hero-gradient (mesh)와 선택적 사용. 정적 페이지나 모바일 성능 우선 시 atmospheric 추천.

## Decorative Heading

Serif/Script 계열 대형 타이포로 섹션 앵커 역할. 브랜드 개성 부여.

```css
.decorative-heading {
  font-family: "Playfair Display", "Noto Serif KR", serif;
  font-size: clamp(5rem, 15vw, 10rem);
  font-weight: 400;
  letter-spacing: -0.02em;
  opacity: 0.9;
  text-align: center;
  line-height: 1;
  padding: 4rem 0;
}
```

대안 폰트: Caveat, Dancing Script, Satisfy (brush 느낌)

## Prose / Markdown Content

각 프로젝트별 `.prose-dark` (dark sites) 또는 `.prose` (light sites) 클래스 제공.
공통 규칙: `max-width: 72ch`, `font-size: 1.0625rem`, `line-height: 1.8`

## Interactive Patterns

CSS-only 우선, 네이티브 HTML 요소 활용(`<dialog>`, `<details>`, `[popover]`). 모든 CSS는 디자인 토큰 변수(`var(--color-*)`, `var(--ease-spring)`, `var(--duration-normal)`)에 fallback 값 포함. Tailwind v4 / Astro 호환.

### Modal / Dialog

네이티브 `<dialog>` 기반. backdrop blur + `@starting-style` entry animation. JS 라이브러리 불필요.

```html
<dialog id="modal" class="modal" aria-modal="true" aria-labelledby="modal-title">
  <div class="modal__content">
    <h2 id="modal-title">제목</h2>
    <p>내용</p>
    <button onclick="this.closest('dialog').close()" aria-label="닫기">✕</button>
  </div>
</dialog>
<button onclick="document.getElementById('modal').showModal()">열기</button>
```

```css
.modal {
  border: 1px solid var(--color-border, rgba(255,255,255,0.08));
  border-radius: var(--radius-xl, 1rem);
  padding: 2rem;
  max-width: min(90vw, 480px);
  background: var(--color-bg-surface, #111);
  color: var(--color-text-primary, #f0f0f0);
  box-shadow: 0 24px 48px rgba(0,0,0,0.3);

  &::backdrop {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
  }

  /* Entry animation */
  opacity: 1;
  transform: scale(1) translateY(0);
  transition:
    opacity 0.3s var(--ease-spring, cubic-bezier(0.16,1,0.3,1)),
    transform 0.3s var(--ease-spring, cubic-bezier(0.16,1,0.3,1)),
    overlay 0.3s allow-discrete,
    display 0.3s allow-discrete;

  @starting-style {
    opacity: 0;
    transform: scale(0.95) translateY(8px);
  }
}

.modal:not([open]) {
  opacity: 0;
  transform: scale(0.95);
}

@media (prefers-reduced-motion: reduce) {
  .modal { transition: none; }
}
```

접근성: `showModal()` 자동 focus trap, Escape 닫기, `aria-modal="true"` + `aria-labelledby` 필수. dark mode: `var(--color-bg-surface)` 토큰으로 자동 적용.

### Accordion / Disclosure

네이티브 `<details>` + CSS transition. `name` 속성으로 exclusive accordion (한 번에 하나만 열림).

```html
<details class="accordion" name="faq">
  <summary class="accordion__trigger">
    <span>질문 내용</span>
    <svg class="accordion__icon" aria-hidden="true" width="20" height="20" viewBox="0 0 20 20">
      <path d="M5 7.5l5 5 5-5" stroke="currentColor" stroke-width="1.5" fill="none"/>
    </svg>
  </summary>
  <div class="accordion__content">
    <p>답변 내용</p>
  </div>
</details>
```

```css
.accordion {
  border: 1px solid var(--color-border, rgba(255,255,255,0.08));
  border-radius: var(--radius-md, 0.5rem);
  overflow: hidden;

  & + & { margin-top: -1px; } /* 연속 배치 시 border 겹침 방지 */
}

.accordion__trigger {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.25rem;
  font-weight: 600;
  cursor: pointer;
  list-style: none;
  transition: background var(--duration-fast, 150ms) var(--ease-out, ease-out);

  &:hover { background: var(--color-bg-hover, rgba(255,255,255,0.04)); }
  &::-webkit-details-marker { display: none; }
}

.accordion__icon {
  width: 1.25rem;
  height: 1.25rem;
  flex-shrink: 0;
  transition: transform var(--duration-normal, 300ms) var(--ease-spring, cubic-bezier(0.16,1,0.3,1));
}

.accordion[open] .accordion__icon {
  transform: rotate(180deg);
}

.accordion__content {
  padding: 0 1.25rem 1rem;
  color: var(--color-text-secondary, #a1a1aa);
  line-height: 1.7;
}

@media (prefers-reduced-motion: reduce) {
  .accordion__icon { transition: none; }
}
```

접근성: `<details>`/`<summary>` 네이티브 `aria-expanded` 자동 제공. `name` 속성은 Chrome 120+, Firefox 130+ 지원.

### Tabs

Semantic tabs with CSS underline indicator. 키보드 Arrow key 전환은 소량의 JS 필요.

```html
<div class="tabs" role="tablist" aria-label="콘텐츠 탭">
  <button role="tab" aria-selected="true" aria-controls="panel-1" id="tab-1" class="tabs__tab">탭 1</button>
  <button role="tab" aria-selected="false" aria-controls="panel-2" id="tab-2" class="tabs__tab" tabindex="-1">탭 2</button>
  <button role="tab" aria-selected="false" aria-controls="panel-3" id="tab-3" class="tabs__tab" tabindex="-1">탭 3</button>
</div>
<div role="tabpanel" id="panel-1" aria-labelledby="tab-1" class="tabs__panel">내용 1</div>
<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" class="tabs__panel" hidden>내용 2</div>
<div role="tabpanel" id="panel-3" aria-labelledby="tab-3" class="tabs__panel" hidden>내용 3</div>
```

```css
.tabs {
  display: flex;
  gap: 0;
  border-bottom: 1px solid var(--color-border, rgba(255,255,255,0.08));
}

.tabs__tab {
  padding: 0.75rem 1.25rem;
  font-weight: 500;
  color: var(--color-text-secondary, #a1a1aa);
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  transition: color var(--duration-fast, 150ms), border-color var(--duration-fast, 150ms);
  cursor: pointer;
  background: none;

  &:hover { color: var(--color-text-primary, #f0f0f0); }

  &[aria-selected="true"] {
    color: var(--color-accent, #2563eb);
    border-bottom-color: var(--color-accent, #2563eb);
    font-weight: 600;
  }
}

.tabs__panel {
  padding: 1.5rem 0;
  animation: tab-enter 0.25s var(--ease-spring, cubic-bezier(0.16,1,0.3,1));
}

@keyframes tab-enter {
  from { opacity: 0; transform: translateY(4px); }
  to   { opacity: 1; transform: translateY(0); }
}

@media (prefers-reduced-motion: reduce) {
  .tabs__panel { animation: none; }
}
```

접근성: `role="tablist"` / `role="tab"` / `role="tabpanel"`, `aria-selected`, `aria-controls`↔`aria-labelledby` 쌍, 비활성 탭 `tabindex="-1"`. dark mode: 토큰으로 자동 처리.

### Toast / Notification

Popover API 기반 fixed-position 알림. `@starting-style`로 slide-up entry.

```html
<div class="toast" role="status" aria-live="polite" popover="manual" id="toast-1">
  <span class="toast__message">저장되었습니다</span>
  <button class="toast__close" popovertarget="toast-1" popovertargetaction="hide" aria-label="닫기">✕</button>
</div>
<!-- 열기: document.getElementById('toast-1').showPopover() -->
```

```css
.toast {
  position: fixed;
  bottom: 1.5rem;
  right: 1.5rem;
  inset: auto 1.5rem 1.5rem auto; /* Popover API 위치 재정의 */
  z-index: var(--z-toast, 500);
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.25rem;
  background: var(--color-bg-surface, #1a1a1a);
  border: 1px solid var(--color-border, rgba(255,255,255,0.08));
  border-radius: var(--radius-lg, 0.75rem);
  box-shadow: 0 8px 24px rgba(0,0,0,0.15);
  font-size: 0.875rem;
  color: var(--color-text-primary, #f0f0f0);
  opacity: 1;
  transform: translateY(0);
  transition:
    opacity 0.3s var(--ease-spring, cubic-bezier(0.16,1,0.3,1)),
    transform 0.3s var(--ease-spring, cubic-bezier(0.16,1,0.3,1));

  @starting-style {
    opacity: 0;
    transform: translateY(1rem);
  }
}

.toast__close {
  padding: 0.25rem;
  opacity: 0.5;
  transition: opacity var(--duration-fast, 150ms);
  background: none;
  cursor: pointer;

  &:hover { opacity: 1; }
}

/* Variants */
.toast--success { border-left: 3px solid var(--color-emerald, #10b981); }
.toast--error   { border-left: 3px solid #ef4444; }
.toast--warning { border-left: 3px solid #f59e0b; }

@media (prefers-reduced-motion: reduce) {
  .toast { transition: none; }
}
```

접근성: `role="status"` + `aria-live="polite"` (에러는 `aria-live="assertive"`). Popover API는 최상위 레이어에 렌더링되어 z-index 충돌 없음.

### Breadcrumb

```html
<nav aria-label="현재 위치" class="breadcrumb">
  <ol>
    <li><a href="/">홈</a></li>
    <li><a href="/programs">프로그램</a></li>
    <li aria-current="page">AI 기초</li>
  </ol>
</nav>
```

```css
.breadcrumb ol {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.25rem;
  list-style: none;
  font-size: 0.875rem;
  color: var(--color-text-secondary, #a1a1aa);
}

.breadcrumb li + li::before {
  content: '/';
  margin-right: 0.25rem;
  opacity: 0.4;
}

.breadcrumb a {
  color: var(--color-text-secondary, #a1a1aa);
  text-decoration: none;
  transition: color var(--duration-fast, 150ms);

  &:hover { color: var(--color-accent, #2563eb); }
  &:focus-visible {
    outline: 2px solid var(--color-accent, #2563eb);
    outline-offset: 2px;
    border-radius: 2px;
  }
}

.breadcrumb [aria-current="page"] {
  color: var(--color-text-primary, #f0f0f0);
  font-weight: 500;
}
```

접근성: `<nav aria-label="현재 위치">` + `<ol>` + `aria-current="page"` 조합. 구조화 데이터(`BreadcrumbList` JSON-LD) 별도 추가 권장.

### Skeleton / Loading

Card shimmer 패턴. `aria-busy`로 로딩 상태 전달. `prefers-reduced-motion` 시 애니메이션 비활성화 필수.

```html
<div class="skeleton-card" aria-busy="true" aria-label="콘텐츠 로딩 중">
  <div class="skeleton__line skeleton__line--title"></div>
  <div class="skeleton__line"></div>
  <div class="skeleton__line skeleton__line--short"></div>
</div>
```

```css
.skeleton__line {
  height: 1rem;
  border-radius: var(--radius-sm, 0.375rem);
  background: linear-gradient(
    90deg,
    var(--color-bg-hover, rgba(255,255,255,0.06)) 25%,
    var(--color-bg-muted, rgba(255,255,255,0.1)) 50%,
    var(--color-bg-hover, rgba(255,255,255,0.06)) 75%
  );
  background-size: 200% 100%;
  animation: skeleton-shimmer 1.5s ease-in-out infinite;

  & + & { margin-top: 0.75rem; }
}

.skeleton__line--title { height: 1.5rem; width: 60%; }
.skeleton__line--short { width: 40%; }

@keyframes skeleton-shimmer {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

@media (prefers-reduced-motion: reduce) {
  .skeleton__line {
    animation: none;
    background: var(--color-bg-hover, rgba(255,255,255,0.06));
  }
}
```

접근성: 로딩 완료 시 `aria-busy="false"` 로 전환, 실제 콘텐츠로 교체. dark mode: 토큰 기반으로 자동 처리.

### Form Input

Input / Select / Checkbox / Radio 공통 스타일. focus ring은 `color-mix()`로 accent 색상 15% 투명도 적용.

```html
<div class="form-group">
  <label class="form-label" for="email">이메일 <span aria-hidden="true">*</span></label>
  <input class="form-input" type="email" id="email" name="email"
    placeholder="example@email.com"
    aria-required="true"
    aria-describedby="email-error" />
  <span class="form-error" id="email-error" role="alert" hidden>올바른 이메일을 입력해주세요</span>
</div>
```

```css
.form-input {
  width: 100%;
  padding: 0.75rem 1rem;
  background: var(--color-bg-surface, #111);
  border: 1.5px solid var(--color-border, rgba(255,255,255,0.08));
  border-radius: var(--radius-md, 0.5rem);
  color: var(--color-text-primary, #f0f0f0);
  font-size: 1rem;
  line-height: 1.5;
  transition: border-color var(--duration-fast, 150ms), box-shadow var(--duration-fast, 150ms);

  &::placeholder { color: var(--color-text-tertiary, #52525b); }

  &:focus {
    outline: none;
    border-color: var(--color-accent, #2563eb);
    box-shadow: 0 0 0 3px color-mix(in srgb, var(--color-accent, #2563eb) 15%, transparent);
  }

  &:invalid:not(:placeholder-shown) {
    border-color: #ef4444;
  }
}

.form-label {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  margin-bottom: 0.375rem;
  color: var(--color-text-secondary, #a1a1aa);
}

.form-error {
  display: block;
  font-size: 0.8125rem;
  color: #ef4444;
  margin-top: 0.375rem;
}

/* Checkbox / Radio */
.form-check {
  appearance: none;
  width: 1.25rem;
  height: 1.25rem;
  border: 1.5px solid var(--color-border, rgba(255,255,255,0.2));
  border-radius: var(--radius-sm, 0.25rem);
  transition: background var(--duration-fast, 150ms), border-color var(--duration-fast, 150ms);
  cursor: pointer;
  flex-shrink: 0;

  &:checked {
    background: var(--color-accent, #2563eb);
    border-color: var(--color-accent, #2563eb);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent, #2563eb);
    outline-offset: 2px;
  }
}

.form-check[type="radio"] { border-radius: 50%; }
```

접근성: `<label for>` + `id` 필수, 에러는 `aria-describedby` + `role="alert"`, 필수 필드 `aria-required="true"`. dark mode: 토큰으로 처리.

### Tooltip / Popover

CSS-only hover tooltip + Popover API click 버전 두 가지 제공.

```html
<!-- CSS-only hover (단순 설명) -->
<span class="tooltip" tabindex="0">
  도움말
  <span class="tooltip__bubble" role="tooltip">이것은 도움말입니다</span>
</span>

<!-- Popover API (클릭, 더 robust) -->
<button popovertarget="help-1" class="btn-icon" aria-label="도움말 보기">?</button>
<div popover id="help-1" class="popover-panel" role="tooltip">
  <p>도움말 내용이 여기에 들어갑니다.</p>
</div>
```

```css
/* CSS-only hover tooltip */
.tooltip {
  position: relative;
  cursor: help;
  display: inline-block;
}

.tooltip__bubble {
  position: absolute;
  bottom: calc(100% + 8px);
  left: 50%;
  transform: translateX(-50%);
  padding: 0.5rem 0.75rem;
  background: var(--color-bg-primary, #0a0a0a);
  border: 1px solid var(--color-border, rgba(255,255,255,0.08));
  border-radius: var(--radius-md, 0.5rem);
  font-size: 0.8125rem;
  white-space: nowrap;
  color: var(--color-text-primary, #f0f0f0);
  pointer-events: none;
  opacity: 0;
  transition: opacity var(--duration-fast, 150ms);
  z-index: var(--z-tooltip, 600);
}

.tooltip:hover .tooltip__bubble,
.tooltip:focus-within .tooltip__bubble {
  opacity: 1;
}

/* Popover API panel */
.popover-panel {
  margin: 0;
  padding: 0.75rem 1rem;
  background: var(--color-bg-surface, #1a1a1a);
  border: 1px solid var(--color-border, rgba(255,255,255,0.08));
  border-radius: var(--radius-md, 0.5rem);
  font-size: 0.875rem;
  color: var(--color-text-primary, #f0f0f0);
  box-shadow: 0 8px 24px rgba(0,0,0,0.2);
  max-width: 280px;
}
```

접근성: CSS-only는 `:focus-within`으로 키보드 접근 지원. Popover API 버전은 Escape 닫기 자동 제공. `role="tooltip"` 필수. dark mode: 토큰으로 처리.

### Dropdown Menu

Popover API 기반 dropdown. `@starting-style` scale-in animation.

```html
<div class="dropdown">
  <button class="dropdown__trigger" aria-haspopup="menu" popovertarget="dropdown-1">
    메뉴 <svg aria-hidden="true" width="16" height="16" viewBox="0 0 16 16">
      <path d="M4 6l4 4 4-4" stroke="currentColor" stroke-width="1.5" fill="none"/>
    </svg>
  </button>
  <div popover id="dropdown-1" class="dropdown__menu" role="menu">
    <a href="#" role="menuitem" class="dropdown__item">항목 1</a>
    <a href="#" role="menuitem" class="dropdown__item">항목 2</a>
    <hr class="dropdown__divider" />
    <a href="#" role="menuitem" class="dropdown__item dropdown__item--danger">삭제</a>
  </div>
</div>
```

```css
.dropdown__menu {
  margin: 0;
  padding: 0.25rem;
  min-width: 12rem;
  background: var(--color-bg-surface, #1a1a1a);
  border: 1px solid var(--color-border, rgba(255,255,255,0.08));
  border-radius: var(--radius-lg, 0.75rem);
  box-shadow: 0 8px 24px rgba(0,0,0,0.2);
  opacity: 1;
  transform: scale(1);
  transition:
    opacity 0.2s var(--ease-spring, cubic-bezier(0.16,1,0.3,1)),
    transform 0.2s var(--ease-spring, cubic-bezier(0.16,1,0.3,1)),
    display 0.2s allow-discrete;

  @starting-style {
    opacity: 0;
    transform: scale(0.95);
  }
}

.dropdown__item {
  display: block;
  padding: 0.625rem 0.75rem;
  border-radius: var(--radius-sm, 0.25rem);
  font-size: 0.875rem;
  color: var(--color-text-primary, #f0f0f0);
  text-decoration: none;
  transition: background var(--duration-fast, 150ms);

  &:hover { background: var(--color-bg-hover, rgba(255,255,255,0.04)); }
  &:focus-visible {
    outline: 2px solid var(--color-accent, #2563eb);
    outline-offset: -2px;
  }
}

.dropdown__item--danger { color: #ef4444; }

.dropdown__divider {
  margin: 0.25rem 0;
  border: none;
  border-top: 1px solid var(--color-border, rgba(255,255,255,0.08));
}

@media (prefers-reduced-motion: reduce) {
  .dropdown__menu { transition: none; }
}
```

접근성: `aria-haspopup="menu"`, `role="menu"`, `role="menuitem"`. Popover API가 focus trap 및 Escape 닫기 제공. dark mode: 토큰으로 처리.

### Pagination

```html
<nav aria-label="페이지 탐색" class="pagination">
  <a href="?page=1" class="pagination__item pagination__item--nav" aria-label="이전 페이지">←</a>
  <a href="?page=1" class="pagination__item">1</a>
  <a href="?page=2" class="pagination__item pagination__item--active" aria-current="page">2</a>
  <a href="?page=3" class="pagination__item">3</a>
  <span class="pagination__ellipsis" aria-hidden="true">…</span>
  <a href="?page=10" class="pagination__item">10</a>
  <a href="?page=3" class="pagination__item pagination__item--nav" aria-label="다음 페이지">→</a>
</nav>
```

```css
.pagination {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  flex-wrap: wrap;
}

.pagination__item {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 2.25rem;
  height: 2.25rem;
  padding: 0 0.5rem;
  border-radius: var(--radius-md, 0.5rem);
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--color-text-secondary, #a1a1aa);
  text-decoration: none;
  transition:
    background var(--duration-fast, 150ms),
    color var(--duration-fast, 150ms);

  &:hover {
    background: var(--color-bg-hover, rgba(255,255,255,0.04));
    color: var(--color-text-primary, #f0f0f0);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent, #2563eb);
    outline-offset: 2px;
  }
}

.pagination__item--active {
  background: var(--color-accent, #2563eb);
  color: white;
  pointer-events: none;
}

.pagination__item--nav {
  color: var(--color-text-tertiary, #52525b);
  font-size: 1rem;
}

.pagination__ellipsis {
  padding: 0 0.25rem;
  color: var(--color-text-tertiary, #52525b);
  user-select: none;
}
```

접근성: `<nav aria-label="페이지 탐색">`, 현재 페이지 `aria-current="page"`, 이전/다음 버튼에 `aria-label`. `…` 은 `aria-hidden="true"` 처리. dark mode: 토큰으로 처리.
