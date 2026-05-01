---
name: design-motion
description: "CSS 애니메이션 패턴 카탈로그 관리 + 재사용. 기존 5개 프로젝트에서 추출한 scroll-reveal, glow, film-grain, gradient-animate, ribbon-scroll, 3D-tilt 등 패턴. 트리거: 애니메이션, animation, motion, micro-interaction, hover, scroll effect, 호버 효과, 스크롤 효과, 인터랙션, 트랜지션, transition"
---

# Design Motion 스킬

기존 5개 프로젝트에서 사용하는 CSS 애니메이션/인터랙션 패턴을 카탈로그로 관리하고,
새 인터랙션 추가 시 일관성과 성능을 보장한다.

## 핵심 원칙

### 1. CSS-only + 모던 CSS API
- JavaScript 애니메이션 라이브러리 사용하지 않음 (Framer Motion, GSAP 등)
- Astro SSG 호환: 빌드 타임에 HTML 생성, JS는 최소화
- IntersectionObserver만 예외 (scroll reveal trigger)
- 모던 CSS 우선 활용:
  - `animation-timeline: scroll()` — 스크롤 연동 (IntersectionObserver 보완)
  - `@starting-style` — entry animation (display:none → block 전환)
  - View Transitions API — Astro 페이지 전환
  - `@property` — 커스텀 프로퍼티 애니메이션 (gradient-angle 등)

### 2. 성능 우선
- `transform` + `opacity` only (layout/paint 유발 속성 금지)
- `will-change`: 필요한 요소에만, hover 시 동적 적용 선호
- `animation-duration`: 0.2s~1.5s 범위 (체감 응답성)
- GPU 가속: `translate3d`, `scale3d` 활용

### 3. 접근성 필수
- 모든 애니메이션에 `prefers-reduced-motion` 대응
- 자동 재생 애니메이션: 정지 가능하거나 reduced-motion에서 비활성화
- 깜빡임: 3회/초 이하

### 4. 일관된 Easing (토큰 사용 권장)
- **Spring**: `var(--ease-spring)` = `cubic-bezier(0.16, 1, 0.3, 1)` — reveal, card hover, button lift
- **Out**: `var(--ease-out)` = `cubic-bezier(0.33, 1, 0.68, 1)` — 일반 transition, fade
- **In-out**: `var(--ease-in-out)` = `cubic-bezier(0.65, 0, 0.35, 1)` — gradient shift, symmetric
- **Linear**: `var(--ease-linear)` = `linear` — ribbon, gradient rotate, continuous
- **Bounce**: `var(--ease-bounce)` = `cubic-bezier(0.34, 1.56, 0.64, 1)` — notification, badge

Duration 토큰: `--duration-fast` (150ms), `--duration-normal` (300ms), `--duration-slow` (500ms), `--duration-reveal` (800ms). 상세는 `design-tokens.md` 참조.

## 패턴 카탈로그

### Scroll Reveal 계열

| 패턴 | 클래스 | 사용 프로젝트 |
|------|--------|-------------|
| Fade up | `.reveal` | youngjoon-lee.com, staixbwlb.com |
| Fade left | `.reveal-left` | youngjoon-lee.com, staixbwlb.com |
| Fade right | `.reveal-right` | youngjoon-lee.com, staixbwlb.com |
| Fade up (alt) | `.fade-up` | halla.ai |
| Hero stagger | `.hero-reveal-1~4` | halla.ai |
| Stagger delay | `.reveal-delay-1~4` | 전체 |

### Glow & Border 계열

| 패턴 | 클래스 | 사용 프로젝트 |
|------|--------|-------------|
| Border glow hover | `.glow-border` | youngjoon-lee.com, staixbwlb.com, halla.ai |
| Card shimmer | `.card::before` | halla.ai |
| Card glow pulse | `.card-bento::after` | halla.ai |
| Neon text | `.neon-text` / `.neon-glow` | youngjoon-lee.com, halla.ai |
| Button glow | `.btn-glow` | 전체 |
| Pulse glow | `@keyframes pulse-glow` | youngjoon-lee.com |

### Gradient Animation 계열

| 패턴 | 클래스 | 사용 프로젝트 |
|------|--------|-------------|
| Hero mesh rotate | `.hero-gradient` | youngjoon-lee.com, staixbwlb.com |
| Hero mesh shift | `.hero-gradient` | youngjoon-lee.com, staixbwlb.com |
| Gradient mesh blobs | `.hero-gradient-mesh` | halla.ai |
| Progress bar | `.progress-bar` | youngjoon-lee.com, staixbwlb.com |
| Card shimmer slide | `@keyframes card-shimmer` | halla.ai |

### Transform 계열

| 패턴 | 클래스 | 사용 프로젝트 |
|------|--------|-------------|
| 3D tilt | `.card-tilt` | youngjoon-lee.com, staixbwlb.com |
| Card lift | `.card-lift` / `.bento-card:hover` | halla.ai, staixbwlb.com |
| Button hover lift | `.btn-solid:hover` | 전체 |
| Bounce Y | `@keyframes bounce-y` | youngjoon-lee.com |

### Continuous 계열

| 패턴 | 클래스 | 사용 프로젝트 |
|------|--------|-------------|
| Ribbon scroll | `.ribbon-track` | youngjoon-lee.com, staixbwlb.com |
| Ribbon reverse | `.ribbon-track-reverse` | youngjoon-lee.com, staixbwlb.com |
| Flow dots | `.flow-dot` | youngjoon-lee.com |
| Film grain | `.grain::after` | youngjoon-lee.com, staixbwlb.com, halla.ai |
| Page fade in | `.page-enter` | staixbwlb.com |

### Scroll-driven 계열 (모던 CSS)

| 패턴 | CSS API | 사용 프로젝트 |
|------|---------|-------------|
| Scroll progress bar | `animation-timeline: scroll(root)` | rise.jeju.ai |
| Scroll reveal (CSS-only) | `animation-timeline: view()` | 신규 권장 |
| Parallax shift | `animation-timeline: scroll()` | 신규 권장 |
| Scroll scale | `animation-timeline: view()` + `animation-range` | 신규 권장 |

### Entry Animation 계열 (모던 CSS)

| 패턴 | CSS API | 용도 |
|------|---------|------|
| Dialog entry | `@starting-style` + `allow-discrete` | Modal/dialog 열림 |
| Popover entry | `@starting-style` + `:popover-open` | Dropdown/tooltip 열림 |
| Toast slide-up | `@starting-style` | 알림 표시 |

### View Transitions 계열

| 패턴 | CSS API | 용도 |
|------|---------|------|
| Page fade | `::view-transition-old/new(root)` | Astro 페이지 전환 |
| Named element | `view-transition-name` | 특정 요소 전환 |
| Persist header | `view-transition-name: header` + `animation: none` | 헤더 유지 |

### Micro-interaction 계열

| 패턴 | 클래스 | 용도 |
|------|--------|------|
| Button press | `.btn-press:active` | `scale(0.97)` 피드백 |
| Toggle switch | `.toggle:checked` | 스위치 전환 |
| Checkbox pop | `.check-animate:checked` | 체크 애니메이션 |
| Input focus glow | `.input-glow:focus` | 포커스 시 glow ring |
| Link underline | `.link-underline:hover` | 밑줄 reveal |
| Icon rotation | `.icon-spin-hover:hover` | 아이콘 회전 |
| Number counter | `@property --num` + `counter()` | 숫자 카운트업 |

## 새 인터랙션 추가 규칙

1. **기존 패턴 확인**: 카탈로그에 유사한 패턴이 있는지 먼저 확인
2. **CSS-only 구현**: JS 필요 시 IntersectionObserver만 허용
3. **모던 CSS 우선**: scroll-driven(`animation-timeline`), entry(`@starting-style`), view transitions 등 네이티브 API 우선 사용
4. **`prefers-reduced-motion` 대응** 반드시 포함
5. **성능 검증**: `transform`/`opacity` only, layout shift 금지
6. **Duration/Easing 토큰 사용**: 하드코딩 대신 `var(--ease-spring)`, `var(--duration-normal)` 등 토큰 참조
7. **Duration 범위**: hover `--duration-fast`~`--duration-normal`, reveal `--duration-reveal`, continuous `--duration-gradient`~`--duration-ribbon`
8. **한 요소에 2개 이상 animation**: comma-separated, 우선순위 명시
9. **Scroll-driven fallback**: `@supports not (animation-timeline: scroll())` 블록으로 미지원 브라우저 대응

## Reduced Motion 템플릿

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
  /* Scroll reveal → 즉시 표시 */
  .reveal, .reveal-left, .reveal-right, .fade-up {
    opacity: 1;
    transform: none;
    transition: none;
  }
  /* Hero → 즉시 표시 */
  .hero-line, .hero-reveal { opacity: 1; transform: none; }
  /* Continuous → 정지 */
  .hero-gradient { animation: none; }
  .ribbon-track, .ribbon-track-reverse { animation: none; }
}
```

## Reference

- `references/motion-library.md` — 각 패턴의 CSS 코드 스니펫 전체
