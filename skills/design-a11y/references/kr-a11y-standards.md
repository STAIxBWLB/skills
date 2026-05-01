# 한국 웹 접근성 기준 요약

한국 웹콘텐츠 접근성 지침 2.2 (KWCAG 2.2) 기반.
국가정보화기본법 제32조, 장애인차별금지법에 따라 공공기관 사이트 의무 준수.

## 4대 원칙

### 1. 인식의 용이성 (Perceivable)

| 지침 | 검사 항목 | Tailwind/CSS 대응 |
|------|----------|------------------|
| 1.1 대체 텍스트 | 이미지 `alt`, 아이콘 `aria-label` | — |
| 1.2 멀티미디어 대체 수단 | 자막, 원고 제공 | — |
| 1.3 색에 무관한 콘텐츠 인식 | 색상만으로 정보 전달 금지 | 아이콘+텍스트 병행 |
| 1.4 명확한 지시 사항 | "여기 클릭" 대신 구체적 지시 | — |
| 1.5 텍스트 콘텐츠 명도 대비 | 4.5:1 이상 | token 색상 검증 |
| 1.6 자동 재생 금지 | 배경 음악 자동 재생 금지 | — |
| 1.7 콘텐츠 간 구분 | 시각적 구분선, 여백 | `section-divider`, spacing |

### 2. 운용의 용이성 (Operable)

| 지침 | 검사 항목 | 대응 |
|------|----------|------|
| 2.1 키보드 사용 보장 | 모든 기능 키보드 접근 | `focus-visible`, tab순서 |
| 2.2 초점 이동 | 논리적 순서, 함정 없음 | focus trap 구현 |
| 2.3 충분한 시간 제공 | 시간 제한 콘텐츠 연장 가능 | — |
| 2.4 정지 기능 제공 | 자동 콘텐츠 일시 정지 | `prefers-reduced-motion` |
| 2.5 깜빡임과 번쩍임 사용 제한 | 3회/초 이하 | animation 검증 |
| 2.6 반복 영역 건너뛰기 | Skip link | `.skip-link` |
| 2.7 제목 제공 | 페이지 `<title>`, heading 계층 | semantic HTML |
| 2.8 적절한 링크 텍스트 | "더보기" 금지, 구체적 텍스트 | aria-label 보충 |

### 3. 이해의 용이성 (Understandable)

| 지침 | 검사 항목 | 대응 |
|------|----------|------|
| 3.1 기본 언어 표시 | `<html lang="ko">` | Astro layout |
| 3.2 사용자 요구에 따른 실행 | 자동 팝업/리다이렉트 금지 | — |
| 3.3 콘텐츠 선형 구조 | CSS 비활성화 시 의미 유지 | semantic HTML |
| 3.4 표의 구성 | `<th>`, `scope`, `caption` | table 구조 |
| 3.5 오류 정정 | 입력 오류 안내, 수정 기회 | form validation |

### 4. 견고성 (Robust)

| 지침 | 검사 항목 | 대응 |
|------|----------|------|
| 4.1 마크업 오류 방지 | valid HTML | — |
| 4.2 웹 애플리케이션 접근성 | WAI-ARIA 준수 | ARIA 속성 |

## 대학 사이트 특별 요구사항

halla.ai, rise.jeju.ai는 대학 관련 사이트로 다음 추가 요구:

### 교육부 권고
- 웹 접근성 품질인증 마크 취득 권장
- 장애 학생 정보 접근 보장
- 모바일 앱 접근성도 동일 기준 적용

### 한글 특화 항목
- 본문 최소 16px, 권장 17px (1.0625rem)
- `line-height: 1.7` 이상 (한글은 영문보다 큰 줄간격 필요)
- `word-break: keep-all` (어절 단위)
- 조사/어미 변화 고려한 텍스트 (`가/이`, `를/을`, `는/은`)
- 전각/반각 문자 혼용 주의

### Tailwind v4 접근성 체크포인트

```css
/* @theme에서 접근성 관련 토큰 */
@theme {
  /* focus ring: accent color 사용 */
  /* text colors: AA contrast ratio 보장 */
}

/* 필수 규칙 */
:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Color Contrast 계산 가이드

### 프로젝트별 주요 조합 검증 필요

**youngjoon-lee.com (light)**:
- `#0f172a` on `#f8fafc` → ~16.3:1 ✓
- `#475569` on `#f8fafc` → ~7.1:1 ✓
- `#94a3b8` on `#f8fafc` → ~3.3:1 ⚠ (대형 텍스트만 OK)

**youngjoon-lee.com (dark)**:
- `#f0f0f0` on `#080808` → ~18.3:1 ✓
- `#a0a0a0` on `#080808` → ~8.5:1 ✓
- `#666666` on `#080808` → ~3.7:1 ⚠ (대형 텍스트만 OK)

**halla.ai (light)**:
- `#0f172a` on `#ffffff` → ~17.4:1 ✓
- `#64748b` on `#ffffff` → ~5.0:1 ✓
- `#0ea5e9` on `#ffffff` → ~3.4:1 ⚠ (대형 텍스트만 OK)

**halla.ai (dark)**:
- `#e2e8f0` on `#050a18` → ~15.7:1 ✓
- `#cbd5e1` on `#050a18` → ~13.1:1 ✓
- `#64748b` on `#050a18` → ~4.3:1 ⚠ (일반 텍스트 기준 미달 근접)

## 테스트 도구

- Chrome DevTools: Lighthouse → Accessibility
- axe DevTools 확장
- WAVE (web accessibility evaluation tool)
- 색상 대비 계산: WebAIM Contrast Checker
- 스크린리더: macOS VoiceOver (Command+F5)
