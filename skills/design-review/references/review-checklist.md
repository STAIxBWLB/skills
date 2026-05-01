# Design Review Checklist

## Token 일관성

- [ ] Hardcoded color → CSS variable 변환
  - `#2563eb` → `var(--color-blue)` 또는 `bg-blue`
  - `#080808` → `var(--color-bg-primary)` 또는 `bg-bg-primary`
  - `rgba(37,99,235,...)` → accent color variable
- [ ] Hardcoded font-family → `var(--font-sans)` / `var(--font-display)` / `var(--font-mono)`
- [ ] Hardcoded border-radius → Tailwind `rounded-*` 또는 CSS variable
- [ ] Hardcoded spacing → Tailwind spacing 유틸리티 또는 CSS variable

## Font & Typography

- [ ] Font fallback 체인 검증 (system-ui, sans-serif 포함)
- [ ] `font-display: swap` 설정 확인 (@font-face)
- [ ] Heading 계층 명확 (h1 > h2 > h3 > body 크기/무게 차이)
- [ ] 한글 `line-height` 최소 1.6 이상 (권장 1.7~1.8)
- [ ] 한글 `letter-spacing` 과도하지 않은지 (0 또는 약간 마이너스)
- [ ] `:lang(ko) { word-break: keep-all; overflow-wrap: break-word; }` 설정

## Dark/Light Mode

- [ ] Light mode 정의된 토큰은 dark mode도 정의
- [ ] `.dark` 클래스 기반 전환 일관성
- [ ] 이미지/아이콘의 dark mode 대응 (invert, swap, opacity 조절)
- [ ] box-shadow: dark에서는 제거 또는 glow로 대체
- [ ] border: dark에서 `rgba(255,255,255,0.06~0.1)` 범위

## 반응형

- [ ] Mobile-first 접근 (base → sm → md → lg → xl)
- [ ] Container `max-width` + `padding-inline` 설정
- [ ] `clamp()` 사용한 fluid typography
- [ ] Touch target 최소 44x44px (모바일 버튼/링크)
- [ ] 가로 스크롤 없음 (`overflow-x: hidden` 또는 적절한 처리)

## Animation & Transition

- [ ] `prefers-reduced-motion` 대응
  - 모든 animation, transition 비활성화
  - reveal 요소는 즉시 visible
- [ ] `will-change` 사용 시 필요한 요소에만 적용
- [ ] `transform` + `opacity` 위주 (layout thrashing 방지)
- [ ] transition duration 일관성 (0.2s~0.4s 범위)
- [ ] easing 함수 일관성 (`cubic-bezier(0.16, 1, 0.3, 1)` 주로 사용)

## 접근성 (기본)

- [ ] Color contrast WCAG AA (4.5:1 text, 3:1 large text)
- [ ] `:focus-visible` outline 설정
- [ ] `::selection` 배경색 설정
- [ ] Skip link 제공 (`.skip-link`)
- [ ] Semantic HTML (nav, main, article, section, aside)

## CSS 품질

- [ ] 미사용 CSS 클래스 없음
- [ ] 불필요한 `!important` 없음
- [ ] Vendor prefix: autoprefixer가 처리하는 것은 수동 작성 불필요
  - 예외: `-webkit-backdrop-filter` (아직 일부 브라우저)
  - 예외: `-webkit-font-smoothing` (Safari)
  - 예외: `-webkit-text-fill-color` (gradient text)
- [ ] `@layer` 사용 시 specificity 충돌 없음
- [ ] CSS custom property 사용 시 fallback 제공 (새 브라우저 전용이면 생략 가능)

## Tailwind v4 준수

- [ ] `@import "tailwindcss"` 최상단
- [ ] `@theme {}` 또는 `@theme extend {}` 안에 토큰 정의
- [ ] `@custom-variant dark` 사용 (class-based)
- [ ] `@plugin` directive 사용 (require 대신)
- [ ] `tailwind.config.js` 파일 없음 (v4 마이그레이션 완료 시)
- [ ] `@source` 경로 설정 (동적 클래스 감지 필요 시)

## 모던 CSS 활용

- [ ] CSS nesting 활용 (중첩 `.parent .child` 대신 `& .child`)
- [ ] `color-mix()` 또는 relative color syntax 사용 (하드코딩 `rgba()` 대신 `rgb(from var(--color) r g b / 0.25)`)
- [ ] `@theme extend` vs `@theme` 적절히 사용 (신규: extend 권장)
- [ ] Container queries 사용 (카드/위젯 컴포넌트 레벨 반응형)
- [ ] `:has()` / `has-*` variant 활용 (부모 조건부 스타일링)
- [ ] `@utility` 사용 (커스텀 유틸리티에 variant 지원)
- [ ] Easing/Duration 토큰 사용 (`var(--ease-spring)`, `var(--duration-normal)`)
- [ ] Z-index scale 토큰 사용 (`var(--z-modal)` 등, 하드코딩 `z-index: 9999` 대신)

## 인터랙티브 패턴

- [ ] Dialog/Modal: `<dialog>` 네이티브 사용 (`showModal()`)
- [ ] Accordion: `<details>` + `<summary>` 네이티브 사용
- [ ] Popover/Dropdown: `[popover]` + `[popovertarget]` 네이티브 사용
- [ ] Entry animation: `@starting-style` 사용 (display:none → block 전환)
- [ ] Toast: `role="status"` + `aria-live="polite"` 접근성 필수
