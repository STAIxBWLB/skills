# 프로젝트별 디자인 시스템 현재 상태

design-review `/roadmap` 실행 시 이 파일과 비교하여 진척도 추적.

최종 분석일: 2026-04-05

---

## youngjoon-lee.com

| 항목 | 값 |
|------|-----|
| 성숙도 | 4.2 / 5 |
| 목표 | 4.8 |
| 컴포넌트 수 | 31 Astro |
| CSS 총 라인 | ~800 (global.css + component styles) |
| @theme 토큰 수 | 28 |
| :root 토큰 수 | 15 (legacy alias 포함) |
| Hardcoded 색상 | 5 (gradient 위주) |
| 접근성 속성 | skip-link ✓, focus-visible ✓, reduced-motion △ (8개 keyframe 중 일부 미대응) |
| Dark mode | ✓ (.dark class toggle) |
| 폰트 | Space Grotesk (display), Pretendard (body), JetBrains Mono (code) |
| 특이사항 | Legacy alias 이중 정의 (old + new) |
| **모던 CSS** | @theme extend ✗, CSS nesting ✗, relative color ✗, scroll-driven ✗ |

## staixbwlb.com

| 항목 | 값 |
|------|-----|
| 성숙도 | 2.8 / 5 |
| 목표 | 4.0 |
| 컴포넌트 수 | 25 Astro |
| CSS 총 라인 | ~600 |
| @theme 토큰 수 | 18 |
| Hardcoded 색상 | 87 |
| 접근성 속성 | skip-link ✗, focus-visible ✗, reduced-motion ✗ |
| Dark mode | dark-only (toggle 없음) |
| 폰트 | Pretendard (body), Space Grotesk (display) |
| 특이사항 | 접근성 기반 부재, hardcoded color 과다 |
| **모던 CSS** | @theme extend ✗, CSS nesting ✗, relative color ✗, scroll-driven ✗ |

## halla.ai

| 항목 | 값 |
|------|-----|
| 성숙도 | 4.3 / 5 |
| 목표 | 4.7 |
| 컴포넌트 수 | 18 Astro (components/) |
| CSS 총 라인 | ~991 (4 모듈: global 49 + base 115 + components 658 + utilities 169) |
| @theme 토큰 수 | 35 |
| .dark rule 수 | 16 |
| Hardcoded 색상 | ~25 (dark text slate 계열 + gradient cyan) |
| 접근성 속성 | skip-link ✓, focus-visible ✓, reduced-motion ✓ (8요소) |
| Dark mode | ✓ (.dark class toggle) |
| 폰트 | Outfit (display), Pretendard (body) |
| Card 컴포넌트 | Card.astro (3 variants: default/flat/bento) |
| 특이사항 | CSS 모듈화 완료, hardcoded color 토큰화 필요 |
| **모던 CSS** | @theme extend ✗, CSS nesting ✗, relative color ✗, scroll-driven ✗ |

## rise.jeju.ai

| 항목 | 값 |
|------|-----|
| 성숙도 | 3.8 / 5 |
| 목표 | 4.2 |
| 컴포넌트 수 | 17 CSS files |
| CSS 총 라인 | ~14,700 (17 파일 합계) |
| variables.css 토큰 수 | 139 (미사용 0) |
| Page-specific CSS | 4 (통합 완료) |
| Hardcoded 색상 | 3 (one-off만 잔존) |
| 접근성 속성 | skip-link ✓, focus-visible ✓, reduced-motion ✓ |
| Dark mode | ✗ (light-only) |
| 폰트 | Pretendard (display), Noto Sans KR + Albert Sans (body) |
| 특이사항 | 토큰 체계 완성, CSS 모듈화 완료, 접근성 3대 기능 구비 |
| **모던 CSS** | @theme extend ✗, CSS nesting ✗, relative color ✗, scroll-driven ✓ (progress bar) |

## koica-tiu (선도 프로젝트)

| 항목 | 값 |
|------|-----|
| 성숙도 | 3.5 / 5 |
| 목표 | 4.5 |
| CSS 구조 | 4 모듈 (global + base + components + utilities) |
| @theme 방식 | `@theme extend {}` (Tailwind 기본값 유지) |
| Hardcoded 색상 | 확인 필요 (relative color syntax 20+ 적용) |
| 접근성 속성 | 확인 필요 |
| Dark mode | 확인 필요 |
| 폰트 | 확인 필요 |
| 특이사항 | 모던 CSS 선도 프로젝트 — 다른 프로젝트의 참조 역할 |
| **모던 CSS** | @theme extend ✓, CSS nesting ✓, relative color ✓ (20+), text-wrap: pretty ✓, scroll-driven ✗ |

## 모던 CSS 채택 현황 요약

| 기능 | youngjoon | staixbwlb | rise | halla | koica-tiu |
|------|-----------|-----------|------|-------|-----------|
| @theme extend | ✗ | ✗ | ✗ | ✗ | ✓ |
| CSS nesting | ✗ | ✗ | ✗ | ✗ | ✓ |
| Relative color | ✗ | ✗ | ✗ | ✗ | ✓ (20+) |
| Scroll-driven | ✗ | ✗ | ✓ | ✗ | ✗ |
| text-wrap: pretty | ✗ | ✗ | ✗ | ✗ | ✓ |
| Easing tokens | ✗ | ✗ | ✗ | ✗ | ✗ |
| Duration tokens | ✗ | ✗ | ✗ | ✗ | ✗ |
| Container queries | ✗ | ✗ | ✗ | ✗ | ✗ |
| @starting-style | ✗ | ✗ | ✗ | ✗ | ✗ |
| @utility | ✗ | ✗ | ✗ | ✗ | ✗ |
