# Project Variants Reference

프로젝트별 디자인 시스템 차이점 상세.

## youngjoon-lee.com

- **특성**: 개인 포트폴리오, 기술 블로그
- **모드**: light + dark (class-based, `@custom-variant dark`)
- **Tailwind**: v4, `@theme` + `@plugin "@tailwindcss/typography"`
- **CSS 파일**: `src/styles/global.css`, `src/styles/fonts.css`
- **Font loading**: Google Fonts (Space Grotesk, JetBrains Mono) + self-hosted Pretendard
- **Legacy**: `--bg-primary`, `--accent` 등 legacy alias와 `--color-*` 신규 토큰 병행
- **특수 효과**: grain overlay, hero mesh (cursor-reactive), ribbon scroll, flow dots
- **한글**: `:lang(ko) { word-break: keep-all; overflow-wrap: break-word; }`

## staixbwlb.com

- **특성**: AI 컨설팅 스타트업, bold creative
- **모드**: dark-only (#080808)
- **Tailwind**: v4, `@theme` inline
- **CSS 파일**: `src/styles/global.css` (단일 파일, fonts 포함)
- **Font loading**: self-hosted (Space Grotesk woff2, Pretendard woff2)
- **특수 효과**: bento grid, 3D tilt shadow, page transitions, progress bar animation
- **Bento variants**: dark, pink, purple, blue, gold, cyan
- **Table**: `.dark-table` 전용 스타일
- **한글**: 동일 `:lang(ko)` 규칙

## rise.jeju.ai

- **특성**: regional innovation 사업 공식 사이트, 47 pages, 5개 전공
- **모드**: light-only (다른 색상 체계)
- **Tailwind**: v4, `@theme` (font만 정의, 나머지는 `:root` CSS variables)
- **CSS 파일**: 모듈화 — `global.css` → `base/variables.css`, `base/utilities.css`, `components/*.css`, `common/*.css`, `layouts/*.css`, `pages/*.css`
- **색상 체계**: 완전 독자적 — primary #2f4cb3 (indigo), accent #4af2c8 (teal)
- **Spacing/Radius/Shadow**: 별도 CSS variables로 체계적 정의
- **컴포넌트**: 별도 CSS 파일로 분리 (navigation, footer, cards, buttons)
- **특수 효과**: 없음 (정적 콘텐츠 사이트)

## halla.ai

- **특성**: AI학과 공식 사이트, 접근성 중요
- **모드**: light + dark (class-based, `@custom-variant dark`)
- **Tailwind**: v4, `@theme` inline
- **CSS 파일**: `src/assets/styles/global.css` (단일 파일, 매우 포괄적 ~1070 lines)
- **테마**: Jeju basalt — navy/void/abyss depth colors
- **Font**: Outfit (display, 영문 heading) + Pretendard Variable (body)
- **카드 시스템**: 3종 (card, card-flat, card-bento) with shimmer/glow effects
- **Hero**: gradient mesh (borrowed from STAIxBWLB), grid overlay, staggered reveal
- **Header**: transparent ↔ solid transition with logo swap
- **Page hero**: Navy gradient with grid pattern + accent glow blob
- **접근성**: `:focus-visible` outline, `prefers-reduced-motion` 대응
- **한글**: body `line-height: 1.7`, heading `letter-spacing: -0.02em`

## ai-systems-2026

- **특성**: Starlight 기반 수업 자료
- **커스텀**: 최소
- **적용**: design-review 시 가독성/접근성 위주
