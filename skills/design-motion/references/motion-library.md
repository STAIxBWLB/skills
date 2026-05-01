# Motion Library — CSS Code Snippets

## 1. Scroll Reveal

### .reveal (fade up)

```css
.reveal {
  opacity: 0;
  transform: translateY(40px);
  transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1),
              transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}
.reveal.visible {
  opacity: 1;
  transform: none;
}
```

### .reveal-left / .reveal-right

```css
.reveal-left {
  opacity: 0;
  transform: translateX(-40px);
  transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1),
              transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}
.reveal-right {
  opacity: 0;
  transform: translateX(40px);
  transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1),
              transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}
.reveal-left.visible,
.reveal-right.visible {
  opacity: 1;
  transform: none;
}
```

### Stagger delays

```css
.reveal-delay-1 { transition-delay: 0.1s; }
.reveal-delay-2 { transition-delay: 0.2s; }
.reveal-delay-3 { transition-delay: 0.3s; }
.reveal-delay-4 { transition-delay: 0.4s; }
```

### .fade-up (halla.ai variant)

```css
.fade-up {
  opacity: 0;
  transform: translateY(32px);
  transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1),
              transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}
.fade-up.visible {
  opacity: 1;
  transform: translateY(0);
}
.fade-up-d1 { transition-delay: 0.1s; }
.fade-up-d2 { transition-delay: 0.2s; }
.fade-up-d3 { transition-delay: 0.3s; }
.fade-up-d4 { transition-delay: 0.4s; }
```

### IntersectionObserver trigger (필수 JS)

```js
// scroll-reveal.js — 모든 프로젝트 공통
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

document.querySelectorAll('.reveal, .reveal-left, .reveal-right, .fade-up')
  .forEach(el => observer.observe(el));
```

## 2. Hero Animations

### Hero kinetic typography

```css
.hero-line {
  display: block;
  opacity: 0;
  transform: translateY(40px);
  animation: line-enter 0.9s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  padding-bottom: 0.2em;
  margin-bottom: -0.2em;
}

@keyframes line-enter {
  from { opacity: 0; transform: translateY(40px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

### Hero stagger reveal (halla.ai)

```css
.hero-reveal {
  opacity: 0;
  animation: hero-reveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
.hero-reveal-1 { animation-delay: 0.15s; }
.hero-reveal-2 { animation-delay: 0.3s; }
.hero-reveal-3 { animation-delay: 0.45s; }
.hero-reveal-4 { animation-delay: 0.6s; }

@keyframes hero-reveal {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

### Hero mesh gradient (cursor-reactive)

```css
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

.hero-gradient {
  background:
    radial-gradient(ellipse at var(--cursor-x, 50%) var(--cursor-y, 50%),
      rgba(37,99,235,0.18) 0%, transparent 60%),
    conic-gradient(
      from var(--gradient-angle) at var(--gradient-pos) 50%,
      rgba(37,99,235,0.12), rgba(34,211,238,0.08),
      rgba(249,115,22,0.06), rgba(37,99,235,0.12)),
    #080808;
  animation: rotate-gradient 12s linear infinite,
             shift-gradient 16s ease-in-out infinite;
}

@keyframes rotate-gradient {
  to { --gradient-angle: 360deg; }
}
@keyframes shift-gradient {
  0%, 100% { --gradient-pos: 30%; }
  50%      { --gradient-pos: 70%; }
}
```

### Hero gradient mesh (halla.ai — blob-based)

```css
.hero-gradient-mesh {
  position: absolute;
  inset: 0;
  overflow: hidden;
}
.hero-gradient-mesh::before {
  content: '';
  position: absolute;
  top: -50%; left: -50%;
  width: 200%; height: 200%;
  background:
    radial-gradient(ellipse at 20% 50%, rgba(14,165,233,0.15) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 20%, rgba(34,211,238,0.1) 0%, transparent 50%),
    radial-gradient(ellipse at 60% 80%, rgba(14,165,233,0.08) 0%, transparent 50%);
  animation: hero-mesh-rotate 20s linear infinite;
}
.hero-gradient-mesh::after {
  content: '';
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse at 70% 30%, rgba(34,211,238,0.12) 0%, transparent 45%),
    radial-gradient(ellipse at 30% 70%, rgba(14,165,233,0.1) 0%, transparent 45%);
  animation: hero-mesh-shift 16s ease-in-out infinite;
}

@keyframes hero-mesh-rotate {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}
@keyframes hero-mesh-shift {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33%      { transform: translate(5%, -3%) scale(1.05); }
  66%      { transform: translate(-3%, 5%) scale(0.97); }
}
```

## 3. Glow & Border Effects

### .glow-border

```css
.glow-border {
  border: 1px solid var(--border);
  box-shadow: var(--shadow-sm);
  transition: border-color 0.3s, box-shadow 0.3s;
}
.glow-border:hover {
  border-color: rgba(37,99,235,0.4);
  box-shadow: var(--shadow-md), 0 0 20px rgba(37,99,235,0.08);
}
```

### Card shimmer (halla.ai)

```css
@keyframes card-shimmer {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

.card::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, transparent 40%, rgba(14,165,233,0.03) 50%, transparent 60%);
  background-size: 400% 100%;
  opacity: 0;
  transition: opacity 0.5s ease;
  pointer-events: none;
}
.card:hover::before {
  opacity: 1;
  animation: card-shimmer 2s ease-in-out;
}
```

### Neon text

```css
.neon-text {
  text-shadow:
    0 0 10px rgba(37,99,235,0.8),
    0 0 20px rgba(37,99,235,0.4),
    0 0 40px rgba(37,99,235,0.2);
}
```

### Pulse glow

```css
@keyframes pulse-glow {
  0%, 100% { box-shadow: 0 0 0 0 rgba(37,99,235,0); }
  50%      { box-shadow: 0 0 24px 4px rgba(37,99,235,0.25); }
}
```

## 4. Transform Effects

### 3D Tilt

```css
.card-tilt {
  transform-style: preserve-3d;
  transition: transform 0.3s ease;
}
.card-tilt:hover {
  transform: perspective(800px) rotateX(3deg) rotateY(-3deg);
}
```

### Card lift

```css
.card-lift {
  transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.35s ease;
}
.card-lift:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 48px rgba(0, 0, 0, 0.08);
}
```

### Button hover lift

```css
.btn-solid:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 30px rgba(37,99,235,0.4);
}
.btn-glow:hover {
  transform: translateY(-1px);
}
```

## 5. Continuous Animations

### Ribbon scroll (infinite marquee)

```css
.ribbon-track {
  display: flex;
  width: max-content;
  animation: ribbon-scroll 30s linear infinite;
}
.ribbon-track-reverse {
  animation: ribbon-scroll-reverse 35s linear infinite;
}

@keyframes ribbon-scroll {
  from { transform: translateX(0); }
  to   { transform: translateX(-50%); }
}
@keyframes ribbon-scroll-reverse {
  from { transform: translateX(-50%); }
  to   { transform: translateX(0); }
}
```

HTML 구조: 콘텐츠를 2배로 복제하여 seamless loop

### Flow dots

```css
.flow-dot {
  position: absolute;
  width: 5px; height: 5px;
  border-radius: 9999px;
  background: var(--accent, #2563eb);
  animation: flow-right 2s linear infinite;
}
.flow-dot-left { animation-name: flow-left; }
.flow-dot-down { animation-name: flow-down; }

@keyframes flow-right { from { left: 0%; } to { left: 100%; } }
@keyframes flow-left  { from { right: 0%; } to { right: 100%; } }
@keyframes flow-down  { from { top: 0%; } to { top: 100%; } }
```

### Film grain overlay

```css
.grain::after {
  content: '';
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 9999;
  opacity: 0.03;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
  background-size: 128px 128px;
}
```

### Page transition

```css
@keyframes page-fade-in {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}
.page-enter {
  animation: page-fade-in 0.4s ease forwards;
}
```

## 6. Stat Counter

```css
@keyframes stat-enter {
  from { opacity: 0; transform: translateY(16px); }
  to   { opacity: 1; transform: translateY(0); }
}
.stat-item { opacity: 0; }
.stat-item.visible {
  animation: stat-enter 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
.stat-item:nth-child(1) { animation-delay: 0s; }
.stat-item:nth-child(2) { animation-delay: 0.1s; }
.stat-item:nth-child(3) { animation-delay: 0.2s; }
.stat-item:nth-child(4) { animation-delay: 0.3s; }
```

## 7. Scroll-driven Animations

CSS-native 스크롤 연동 애니메이션. IntersectionObserver 없이 CSS만으로 스크롤 진행도에 비례하는 연속 애니메이션 구현.

### 스크롤 진행 표시줄 (rise.jeju.ai 실사용)

```css
.scroll-progress {
  position: fixed;
  top: 0;
  left: 0;
  width: 0%;
  height: 3px;
  background: linear-gradient(90deg, var(--color-blue, #2563eb), var(--color-cyan, #22d3ee));
  z-index: var(--z-sticky, 200);
  animation: grow-width linear;
  animation-timeline: scroll(root);
}
@keyframes grow-width {
  from { width: 0%; }
  to { width: 100%; }
}
```

### 요소별 스크롤 진입 애니메이션

```css
.scroll-reveal {
  opacity: 0;
  transform: translateY(30px);
  animation: scroll-fade-in linear both;
  animation-timeline: view();
  animation-range: entry 0% entry 100%;
}
@keyframes scroll-fade-in {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}
```

### 패럴랙스 효과

```css
.parallax-slow {
  animation: parallax-shift linear;
  animation-timeline: scroll();
}
@keyframes parallax-shift {
  from { transform: translateY(-20%); }
  to { transform: translateY(20%); }
}
```

### 스크롤 기반 scale

```css
.scroll-scale {
  animation: scroll-grow linear;
  animation-timeline: view();
  animation-range: entry 0% cover 50%;
}
@keyframes scroll-grow {
  from { transform: scale(0.8); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}
```

핵심 API:
- `animation-timeline: scroll()` — 페이지 전체 스크롤 진행도
- `animation-timeline: scroll(root)` — 루트 요소 스크롤
- `animation-timeline: view()` — 요소가 뷰포트에 진입/퇴장하는 진행도
- `animation-range` — 애니메이션 시작/끝 지점 (`entry`, `exit`, `cover`, `contain`)

기존 IntersectionObserver 방식과의 차이:
- 장점: JS 불필요, 스크롤 위치에 비례하는 연속 애니메이션 가능
- 단점: 브라우저 지원 (Chrome 115+, Safari 미지원 2025 기준)
- 권장: 진행 표시줄 등 progressive enhancement로 사용, 핵심 기능에는 IntersectionObserver 유지

```css
/* Fallback — scroll-driven 미지원 시 */
@supports not (animation-timeline: scroll()) {
  .scroll-progress { display: none; }
  .scroll-reveal { opacity: 1; transform: none; }
}
```

## 8. View Transitions

페이지 전환 애니메이션. Astro View Transitions와 통합.

### 기본 페이지 전환 (fade)

```css
/* Astro에서 활성화: <ViewTransitions /> in Base.astro */

::view-transition-old(root) {
  animation: fade-out 0.2s ease-in;
}
::view-transition-new(root) {
  animation: fade-in 0.3s var(--ease-spring, cubic-bezier(0.16, 1, 0.3, 1));
}

@keyframes fade-out {
  to { opacity: 0; }
}
@keyframes fade-in {
  from { opacity: 0; transform: translateY(4px); }
  to { opacity: 1; transform: translateY(0); }
}
```

### Named transition (특정 요소)

```css
.hero-image {
  view-transition-name: hero-image;
}
::view-transition-old(hero-image) {
  animation: scale-out 0.3s ease-in;
}
::view-transition-new(hero-image) {
  animation: scale-in 0.3s var(--ease-spring);
}

@keyframes scale-out {
  to { transform: scale(0.95); opacity: 0; }
}
@keyframes scale-in {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

/* Header persist (전환 시 유지) */
.site-header {
  view-transition-name: header;
}
::view-transition-old(header),
::view-transition-new(header) {
  animation: none; /* 유지 — 전환 없음 */
}
```

### Astro 통합

```astro
---
// Base.astro
import { ViewTransitions } from 'astro:transitions';
---
<head>
  <ViewTransitions />
</head>
```

요소에 transition 지정:
```astro
<img transition:name="hero-image" src={src} alt={alt} />
<header transition:persist>...</header>
```

## 9. Entry Animations (`@starting-style`)

`display: none` → `display: block` 전환 시 애니메이션. Dialog, popover, dropdown에 필수.

### Dialog entry / exit

```css
dialog[open] {
  opacity: 1;
  transform: scale(1);
  transition: opacity var(--duration-slow, 500ms) var(--ease-spring),
              transform var(--duration-slow, 500ms) var(--ease-spring),
              overlay var(--duration-slow, 500ms) allow-discrete,
              display var(--duration-slow, 500ms) allow-discrete;

  @starting-style {
    opacity: 0;
    transform: scale(0.95) translateY(8px);
  }
}
/* Dialog exit — closed 상태 */
dialog:not([open]) {
  opacity: 0;
  transform: scale(0.95);
  transition: opacity var(--duration-normal, 300ms),
              transform var(--duration-normal, 300ms),
              overlay var(--duration-normal, 300ms) allow-discrete,
              display var(--duration-normal, 300ms) allow-discrete;
}

/* Backdrop animation */
dialog::backdrop {
  background: rgba(0, 0, 0, 0.5);
  opacity: 1;
  transition: opacity var(--duration-normal, 300ms);

  @starting-style { opacity: 0; }
}
```

### Popover entry

```css
[popover]:popover-open {
  opacity: 1;
  transform: scale(1) translateY(0);
  transition: opacity 0.2s var(--ease-spring),
              transform 0.2s var(--ease-spring),
              overlay 0.2s allow-discrete,
              display 0.2s allow-discrete;

  @starting-style {
    opacity: 0;
    transform: scale(0.95) translateY(-4px);
  }
}
```

### Dropdown / Toast entry

```css
/* Dropdown entry (위에서 아래로) */
.dropdown-enter {
  opacity: 1;
  transform: translateY(0);
  transition: opacity 0.15s var(--ease-out),
              transform 0.15s var(--ease-out);

  @starting-style {
    opacity: 0;
    transform: translateY(-8px);
  }
}

/* Toast entry (아래에서 위로) */
.toast-enter {
  opacity: 1;
  transform: translateY(0);
  transition: opacity 0.3s var(--ease-spring),
              transform 0.3s var(--ease-spring);

  @starting-style {
    opacity: 0;
    transform: translateY(16px);
  }
}
```

핵심:
- `@starting-style` — 요소가 처음 표시될 때의 초기 상태 정의
- `transition-behavior: allow-discrete` — `display`, `overlay` 등 이산 속성의 전환 허용
- `overlay` — top layer 진입/퇴장 시 전환 가능하게 함

## 10. Micro-interactions

버튼, 토글, 체크박스 등의 작은 인터랙션 피드백.

### Button press

```css
.btn-press {
  transition: transform var(--duration-instant, 100ms) var(--ease-out);

  &:active {
    transform: scale(0.97);
  }
}
/* 기존 btn-glow, btn-solid에 추가 적용 가능 */
```

### Toggle switch

```css
.toggle {
  position: relative;
  width: 2.75rem;
  height: 1.5rem;
  background: var(--color-border);
  border-radius: 9999px;
  cursor: pointer;
  transition: background var(--duration-normal, 300ms) var(--ease-spring);
}
.toggle::after {
  content: '';
  position: absolute;
  top: 2px;
  left: 2px;
  width: 1.25rem;
  height: 1.25rem;
  background: white;
  border-radius: 50%;
  transition: transform var(--duration-normal, 300ms) var(--ease-spring);
  box-shadow: 0 1px 3px rgba(0,0,0,0.2);
}
.toggle:checked {
  background: var(--color-accent, #2563eb);
}
.toggle:checked::after {
  transform: translateX(1.25rem);
}
```

### Checkbox check animation

```css
.check-animate {
  &:checked {
    animation: check-pop 0.3s var(--ease-bounce);
  }
}
@keyframes check-pop {
  0% { transform: scale(1); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}
```

### Form input focus glow

```css
.input-glow:focus {
  box-shadow: 0 0 0 3px rgb(from var(--color-accent, #2563eb) r g b / 0.15);
  border-color: var(--color-accent);
  transition: box-shadow var(--duration-fast, 150ms), border-color var(--duration-fast, 150ms);
}
```

### Icon hover rotation

```css
.icon-spin-hover {
  transition: transform var(--duration-normal, 300ms) var(--ease-spring);

  &:hover { transform: rotate(90deg); }
}
```

### Link underline reveal

```css
.link-underline {
  text-decoration: none;
  background-image: linear-gradient(var(--color-accent), var(--color-accent));
  background-size: 0% 1.5px;
  background-position: 0% 100%;
  background-repeat: no-repeat;
  transition: background-size var(--duration-normal) var(--ease-spring);

  &:hover { background-size: 100% 1.5px; }
}
```

### Number counter (CSS `@property`)

```css
@property --num {
  syntax: '<integer>';
  initial-value: 0;
  inherits: false;
}
.counter {
  counter-reset: num var(--num);
  animation: count-up 2s var(--ease-out) forwards;
}
.counter::after {
  content: counter(num);
}
@keyframes count-up {
  from { --num: 0; }
  to { --num: var(--target, 100); }
}
```

### Reduced motion (모든 micro-interactions 공통)

```css
@media (prefers-reduced-motion: reduce) {
  .btn-press:active { transform: none; }
  .toggle::after { transition-duration: 0.01ms; }
  .check-animate:checked { animation: none; }
  .icon-spin-hover:hover { transform: none; }
  .link-underline { background-size: 100% 1.5px; } /* 항상 표시 */
  .counter { animation-duration: 0.01ms; }
}
```

## Animation Combination Rules

한 요소에 여러 animation 적용 시:

1. **Comma-separated**: `animation: rotate 12s linear infinite, shift 16s ease-in-out infinite;`
2. **우선순위**: transform 애니메이션은 하나만 (충돌 방지)
3. **Pseudo-elements 활용**: `::before`/`::after`에 별도 animation 분리
4. **Duration 조화**: 관련 애니메이션은 배수 관계 (12s + 16s, 30s + 35s)
