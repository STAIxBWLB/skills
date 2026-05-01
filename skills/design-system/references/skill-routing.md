# Design Skill Routing Guide

15+ 디자인 스킬 간 선택 기준과 충돌 해결 규칙.

## 스킬 카탈로그

### 내부 스킬 (Primary — 항상 우선)

프로젝트 디자인 시스템의 공식 규칙. 코드 생성 시 반드시 참조.

| 스킬 | 트리거 | 역할 |
|------|--------|------|
| **design-system** | 컴포넌트 개발, 토큰 조회, 프로젝트 규칙 | 디자인 시스템 허브. 토큰, 컴포넌트, Tailwind v4 규칙, 프로젝트별 변형 |
| **design-init** | 새 프로젝트, 디자인 초기화 | 5단계 인터뷰 → global.css + fonts.css + Base.astro 생성 |
| **design-motion** | 애니메이션, 인터랙션, hover, scroll | CSS 애니메이션 카탈로그 (scroll reveal, hero, glow, transform, continuous, scroll-driven, view transitions, entry, micro) |
| **design-review** | /polish, /audit, /distill, /roadmap | 디자인 검수 4모드. 토큰 일관성, CSS 정리, 개선 로드맵 |
| **design-a11y** | 접근성, a11y, WCAG, 웹접근성 | KWCAG 2.2 기반 한국 웹접근성 검수. 공공기관/대학 수준 |

### 외부 스킬 (Secondary — 미학/원칙만 참조)

디자인 철학과 미적 원칙만 참조. 기술 구현(프레임워크, 라이브러리)은 무시.

| 스킬 | 언제 사용 | 채택 범위 | 무시할 것 |
|------|----------|----------|----------|
| **design-taste-frontend** | "고급스러운 UI" 요청 | 디자인 원칙, metric 기반 규칙, anti-generic 패턴 | React, Framer Motion 권장 → Astro/CSS-only로 적용 |
| **high-end-visual-design** | Awwwards급 비주얼 요청 | Double-bezel 아키텍처, luxury texture, 모션 안무 원칙 | GSAP, Three.js, ScrollTrigger → CSS scroll-driven으로 대체 |
| **make-interfaces-feel-better** | UI polish, "느낌 좋게" 요청 | Concentric radius, optical alignment, spring physics 원칙 | 프레임워크 특정 구현 |
| **minimalist-ui** | "미니멀하게", "클린하게" 요청 | Warm monochrome, typographic contrast, bento grid 원칙 | Inter/Roboto 금지 규칙 (우리 프로젝트는 Pretendard/Space Grotesk 사용 — OK) |
| **industrial-brutalist-ui** | "브루탈리스트", "인더스트리얼" 요청 | Swiss typography, monospace, 90도 각도 | border-radius 금지 규칙 (프로젝트 기존 radius 유지) |
| **redesign-existing-projects** | 기존 사이트 리디자인 감사 | 감사 절차, generic AI pattern 감지, upgrade 기법 | 새 프레임워크 도입 권장 |
| **stitch-design-taste** | Google Stitch용 DESIGN.md | Semantic design language, configuration dials | 우리 프로젝트에는 미적용 (Stitch 전용) |
| **better-icons** | 아이콘 검색, SVG 적용 | Iconify 검색, SVG 최적화 | 전체 채택 (충돌 없음) |

### 플러그인 스킬 (Tertiary — 일반 지식)

| 스킬 | 언제 사용 | 채택 범위 |
|------|----------|----------|
| **frontend-design:frontend-design** | 일반 프론트엔드 디자인 원칙 | Design thinking 프레임워크, 차별화 원칙 |
| **ui-ux-pro-max:ui-ux-pro-max** | 스타일 팔레트, 폰트 페어링 참조 | 161 color palettes, 57 font pairings 데이터베이스 |

## 라우팅 결정 트리

```
사용자 요청 수신
├── "새 프로젝트" / "디자인 초기화" → design-init
├── "접근성" / "a11y" / "WCAG" → design-a11y
├── "애니메이션" / "hover" / "scroll effect" → design-motion
├── "/polish" / "/audit" / "/distill" / "/roadmap" → design-review
├── "아이콘" → better-icons
├── 컴포넌트 개발 / 토큰 조회 → design-system
│
├── 스타일 방향 요청 시 (외부 스킬 보조 참조):
│   ├── "고급스러운" / "프리미엄" → design-taste-frontend + design-system
│   ├── "Awwwards급" / "럭셔리" → high-end-visual-design + design-system
│   ├── "미니멀" / "클린" → minimalist-ui + design-system
│   ├── "브루탈리스트" / "인더스트리얼" → industrial-brutalist-ui + design-system
│   ├── "polish" / "느낌 좋게" → make-interfaces-feel-better + design-review
│   └── "리디자인" / "업그레이드" → redesign-existing-projects + design-review
│
└── 기본 (방향 지정 없음) → design-system
```

## 충돌 해결 규칙

### Rule 1: 내부 > 외부
내부 스킬의 토큰/패턴/규칙이 항상 우선. 외부 스킬이 `#3B82F6` 사용을 권장해도 우리 프로젝트의 `var(--color-accent)` 토큰을 사용.

### Rule 2: CSS-only > JS 라이브러리
모든 프로젝트는 Astro SSG + CSS-only 철학. 외부 스킬이 Framer Motion, GSAP, ScrollTrigger 등을 권장하면:
- Framer Motion → CSS transition + @starting-style
- GSAP ScrollTrigger → CSS scroll-driven animations (animation-timeline)
- Three.js → CSS 3D transforms (perspective, rotateX/Y)
- React state → CSS :has(), :checked, [open] 등 네이티브 상태

### Rule 3: 기존 패턴 > 새 패턴 도입
프로젝트에 이미 확립된 패턴이 있으면 그것을 따름:
- 기존 `.btn-glow` 있으면 외부 스킬의 새 버튼 패턴 대신 `.btn-glow` 변형
- 기존 `.reveal` 있으면 외부 스킬의 새 scroll animation 대신 `.reveal` 확장
- 기존 color token 체계 있으면 외부 스킬의 새 색상 시스템 대신 기존 토큰 추가

### Rule 4: 미학만 채택, 구현은 내부
외부 스킬에서 채택하는 것:
- 디자인 원칙 (e.g., "concentric border radius", "optical alignment")
- 미적 방향 (e.g., "double-bezel architecture", "warm monochrome palette")
- 반(anti) 패턴 지적 (e.g., "generic AI look", "default shadows")

외부 스킬에서 무시하는 것:
- 프레임워크 권장 (React, Vue, Svelte)
- JS 라이브러리 권장 (GSAP, Framer Motion, Three.js)
- 폰트 금지 규칙 (우리 프로젝트 폰트 스택은 design-system이 관리)
- border-radius 금지 (우리 프로젝트는 radius 사용)
- 색상 하드코딩 (우리는 토큰 시스템 사용)

### Rule 5: 프로젝트 감지 후 적용
컴포넌트 개발 시 반드시 프로젝트를 먼저 감지:
1. 작업 디렉토리에서 프로젝트 판별 (design-system의 프로젝트 감지 규칙)
2. 해당 프로젝트의 design-tokens, project-variants 로드
3. 외부 스킬의 미학 원칙을 프로젝트 토큰으로 변환하여 적용

## 동시 적용 예시

### "halla.ai에 고급스러운 FAQ 섹션 추가"

1. **design-system** (primary): halla.ai 프로젝트 감지 → Jeju basalt theme 토큰 로드
2. **design-taste-frontend** (secondary): "고급스러운" → anti-generic 원칙, metric-based spacing 참조
3. **design-system/component-patterns**: Accordion 패턴 참조
4. **design-motion**: Accordion 열림/닫힘 easing → `var(--ease-spring)`
5. **design-a11y**: `<details>` 네이티브 접근성, `aria-expanded` 확인

결과: halla.ai 토큰 + Accordion 패턴 + spring easing + KWCAG 접근성 → CSS-only 구현

### "staixbwlb.com을 Awwwards급으로 업그레이드"

1. **redesign-existing-projects** (secondary): 현재 디자인 감사 → generic 패턴 감지
2. **high-end-visual-design** (secondary): luxury texture, double-bezel 아키텍처 원칙
3. **design-system** (primary): staixbwlb.com dark-only 토큰 로드
4. **design-review /roadmap**: 현재 성숙도 2.8/5, Phase 1 (접근성+토큰화) 우선
5. **design-motion**: 3D tilt, glow-pulse → scroll-driven + @starting-style 확장

Note: Awwwards급이어도 접근성(Phase 1)이 먼저. 화려함보다 기반 구축 우선.
