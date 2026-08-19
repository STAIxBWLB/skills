---
name: hwpx
description: >
  한국 공문서 스타일의 HWPX 문서 작성·편집 스킬. 공문서, 기안문(내부결재/대외시행),
  사업계획서, 보고서, 회의록 템플릿 + {{anchor}} 치환 기반 문서 생성. 생성·변환·렌더는
  hwp-cli(Rust) 네이티브에 위임(읽기·편집·검증·HTML·텍스트선택 PDF·이미지 렌더·수식 자동조판·
  표 행/열 추가·삭제·셀 병합/분할(병합 셀 표 지원)·RISE 스타일 사다리·
  구조 편집 프리미티브[누름틀·책갈피·하이퍼링크·이미지 삽입·문단 정렬/서식·문단 삽입/삭제]·
  추출근거 세그먼트 맵), 슬롯/구조 편집은 lxml.
  조회 커맨드: info(포맷/스트림)·fields(누름틀)·bookmarks·slots. 템플릿 채우기 중심.
  트리거: hwpx, 공문, 공문서, 기안문, 결재문서, 내부결재, 대외시행, 사업계획서, 보고서,
  회의록, 한글 문서 작성, .hwpx 생성/수정, 수식, 필드, 누름틀, 책갈피, 하이퍼링크, 이미지 삽입,
  표 행 추가, 표 열 추가, 표 행 삭제, 표 열 삭제, 셀 병합, 셀 분할, 문단 정렬, 글자 서식,
  공문 써줘, 기안문 만들어줘, 한컴 문서
  docx 출력(convert --to docx, hwp-cli v0.7.0+).
  사용하지 않음: 바이너리 .hwp 직접 파싱 (→ hwp-cli; read는 자동 위임),
  .docx 읽기·편집 (→ docx 스킬; 이 스킬은 docx 출력만), .pdf
---

# hwpx — HWPX 공문서/기안문 authoring toolkit

## Overview

HWPX는 한/글(Hancom Office)의 **XML 기반 공식 포맷**이며, 2021년부터 대한민국 정부 공문서의 법정 저장 형식이다. 내부 구조는 zip + OWPML(Open Word-Processor Markup Language, KS X 6101). 이 스킬은 raw ZIP/XML 처리(lxml, 슬롯·구조 편집)와 hwp-cli(Rust) 네이티브 위임(생성·변환·렌더·검증)을 사용하여 다섯 가지 작업 경로를 지원한다:

1. **양식 따라가기 (`styled --reference`)** — 주어진 공식 양식 파일의 폰트·여백·스타일을 그대로 사용하여 본문만 채움. 사업 공고 HWP 양식이 있을 때 최우선 경로.
2. **신규 생성 (`styled` / `create`)** — 양식이 없을 때 `hwp new` + **공문서 기본 스타일 후처리 자동 적용**(표 칼럼 폭 내용 비례·헤더행 #F2F2F2 음영+굵게+가운데·짧은 칼럼 가운데·제목 가운데 15pt — corpus 근거 `references/style-patterns.md`). `styled --preset`은 기안문/보고서의 폰트·여백·번호·쪽번호를 hwp-cli에 적용하고, `--plain`은 후처리만 생략.
3. **템플릿 채우기 (`fill`)** — 내장 `templates/*.hwpx`의 `{{anchor}}` 치환. 기안문/사업계획서 뼈대 사용.
4. **편집** (`edit`, `edit-section`, `unpack`+`repack`) — 기존 문서 수정.
5. **레퍼런스 양식 복원·편집 (`analyze` → `fill`/`edit-section` → `validate` → `guard`)** — 첨부된 임의 공문 양식의 서식·구조를 보존하며 본문만 안전하게 교체하는 권장 경로. 아래 "robust 편집 엔진" 참조.

### robust 편집 엔진 (`scripts/hwpx_xml.py`)

`edit`/`edit-section`/`fill-form`/`analyze`/`guard`/`styled --reference`는 직렬화 문자열 치환이 아니라 **lxml 트리 편집 엔진**을 쓴다(`fill`·`slots`는 충실도 보존을 위해 hwp-cli `fill`/`slots`에 위임). 핵심 보장:
- **run 경계를 넘나드는 `{{anchor}}`도 매칭** (`<hp:t>` 텍스트를 연결해 치환, 앵커 밖 run·서식은 보존).
- **`<hp:linesegarray>` 자동 삭제** — 텍스트 수정 후 줄배치 캐시를 지워 글자 겹침 방지(한글이 열 때 재계산).
- **sec 직계자식 인덱스 기반** 섹션 경계 처리 (텍스트 검색 아님), **deepcopy 참조 단락 복제**, mimetype-first STORED 재패키징.
- 편집 엔진 의존성은 lxml뿐 (python-hwpx·번들 Java 미사용). 생성·변환·렌더는 hwp-cli 위임.

바이너리 `.hwp`(v5 OLE2 포맷)의 읽기·변환은 **hwp-cli**(Rust 단일 바이너리 `hwp`)로 처리한다 — `./hwpx read legacy.hwp`가 자동 위임. 이 스킬 자체는 HWPX 작성·편집 전용.

## 업스트림 경계 (hwp-cli 일반 사용법은 여기 없음)

hwp-cli는 v0.8.0부터 **자체 에이전트 스킬을 바이너리에 내장**한다. 일반 CLI·MCP 표면
(전체 서브커맨드, `edit` 31종 플래그, 16개 MCP 툴, safety rules)의 정본은 그쪽이고,
이 스킬은 그것을 복제하지 않는다.

```bash
hwp skill export -o /tmp/hwp-skill   # 내장 SKILL.md 꺼내 읽기 (v0.8.0+)
hwp <커맨드> --help                   # 플래그 정본
```

정적 사본은 `~/workspace/work/dev/hwp-cli/docs/manual/cli-reference.md`
(clap 정의에서 자동 생성, upstream CI가 코드-문서 동기화를 강제). 플래그가 이 SKILL.md와
어긋나면 그쪽이 맞다.

**이 스킬이 소유하는 것** — upstream 어디에도 없는 워크스페이스 레이어:

- 한국 공문서 작성 규정·개조식 기호 사다리 (§한국 공문서 작성 규정, §개조식 기호 사다리)
- `templates/*.hwpx` 6종과 공통 슬롯 명 (§2)
- 공문서 스타일 후처리 `scripts/style_pass.py` (§1, §5-A)
- 구조 드리프트 게이트 `scripts/page_guard.py` (`./hwpx guard`, §4)
- lxml run-aware 슬롯·섹션 편집 `scripts/hwpx_xml.py` (§4)
- `./hwpx` 래퍼와 바이너리 탐색 규칙 (§10)

### MCP

`mcp__hwp__*` 서버가 등록돼 있으면 16개 툴이 CLI와 같은 일을 한다(툴 목록·인자는 upstream
스킬이 정본). 이 스킬의 기본 경로는 여전히 CLI다 — 슬롯·섹션 편집과 style_pass·guard는
MCP에 없는 lxml 경로이기 때문이다. 서버는 항상 `--root <작업디렉터리>`로 샌드박싱해
띄운다(v0.8.0+, 미지정이면 무제한이고 stderr에 경고만 남는다).

## Quick Reference

| 작업 | 명령 |
|------|------|
| 읽기 (markdown) | `./hwpx read <file.hwpx>` (text/md는 hwp-cli `cat` 우선·lxml 폴백) |
| 메타 요약 | `./hwpx summary <file.hwpx>` |
| 구조화 JSON | `./hwpx read <file.hwpx> --format json` |
| **보기 좋은 생성 (양식 없음)** | `./hwpx styled --preset gongmun|bogoseo --markdown <md> -o <out>` (`gian|report`도 허용, `--plain`은 후처리만 생략) |
| **양식 따라가기** | `./hwpx styled --reference <양식.hwpx> --markdown <md> -o <out>` |
| **기존 파일 표/제목 다듬기** | `./hwpx beautify <file.hwpx> [-o out] [--header-fill "#D9E2F3"]` |
| 템플릿 채우기 (run-aware) | `./hwpx fill <template> --kv key=value -o out.hwpx` |
| find/replace (run-aware) | `./hwpx edit <in> <out> --replace OLD NEW` |
| **표 행/열 추가 (양식 변형)** | `./hwpx add-rows <file> --table 0 --count 3 --set-cell "0:1:0=값" -o out` · `./hwpx add-col <file> --table 0 -o out` |
| **표 구조 편집 (위치삽입·삭제·병합)** | `hwp edit <in> -o <out> --add-row "0:1:2"` · `--add-col "0:1"` · `--delete-row` · `--delete-col` · `--merge-cells` · `--split-cell` (§4) |
| **누름틀 생성 / 채우기 (결재·수신 양식)** | `hwp edit <in> -o <out> --create-field "앵커=>이름[=값]"` · `--set-field "이름=값"` |
| **도장 날인 ((인) 앵커)** | `hwp edit <in> -o <out> --seal "(인)=>seal.png[@18mm]"` |
| 그 밖의 `hwp edit` 플래그 (이미지·정렬·서식·문단·페이지설정·표 복제) | `hwp edit --help` — §업스트림 경계 |
| 조회·변환·렌더 passthrough | `./hwpx info` · `fields` · `bookmarks` · `render` · `convert` (hwp-cli 위임) |
| **데이터 구동 표 채우기 (행 자동 증식)** | `./hwpx fill-table <file> --data tables.json -o out` |
| **편집 청사진 (sec 인덱스 맵)** | `./hwpx analyze <file.hwpx>` |
| **본문 단락 범위 교체** | `./hwpx edit-section <file> --start N --end M --lines lines.txt -o out` |
| **라벨-값 양식 채우기** | `./hwpx fill-form <form> --kv 성명=홍길동 --kv 소속=… -o out` |
| **드리프트 게이트 (구조 보존 검증)** | `./hwpx guard --reference <ref> --output <out>` (렌더 안 함 — 실제 쪽수는 `hwp render --report`) |
| unpack → XML 직접 편집 | `./hwpx unpack <file> <dir>` → `./hwpx repack <dir> <out>` |
| 단순 신규 생성 | `./hwpx create <out> --title T --body "1줄\n2줄"` (→ hwp-cli new) |
| markdown → HWPX (레거시 별칭) | `./hwpx write-java <out> --markdown <md>` (→ hwp-cli new) |
| 검증 | `./hwpx validate <file.hwpx>` |
| PDF 변환 | `./hwpx to-pdf <file.hwpx>` (기본 hwp-cli 네이티브 **텍스트 선택가능** PDF; `--engine soffice` 폴백) |

경로 기준: `~/.maru/skills/hwpx/hwpx`

## 한국 공문서 작성 규정 (핵심 cheat sheet)

근거: 「행정 효율과 협업 촉진에 관한 규정 시행규칙」 별표 서식. 상세는 `references/korean-official-format.md`.

| 항목 | 규정 |
|------|------|
| 용지 | A4 세로 |
| 여백 | 위 30mm / 아래 15mm / 왼쪽 20mm / 오른쪽 15mm |
| 본문 폰트 (기안문 현행) | **맑은 고딕 11.5pt**, 장평 100, 자간 0 |
| 본문 폰트 (보고서 전통) | **휴먼명조 15pt** 또는 함초롬바탕 15pt |
| 줄간격 | **160%** |
| 종결 방식 | **개조식** (명사형: "~함", "~임", "~할 것") — 상세는 `gaejosik` 스킬 |
| 번호 체계 | **4단계**: `1.` → `가.` → `1)` → `가)` |
| 붙임 표기 | "붙임  1. 파일명 1부." + 마지막에 "**끝.**" |
| 페이지 번호 | 하단 중앙, "n/총페이지" 또는 숫자만 |
| 관인(직인) | **전자결재 시스템이 자동 삽입** — 스킬이 생성하지 않음 |

## 개조식 기호 사다리

본문 항목 기호는 4단 사다리를 쓴다: `□`(U+25A1) → `○`(U+25CB) → `-` → `·`(U+00B7).
원 기호는 `○`만 사용하고 `◦`·ASCII `o`·`ㅇ`·`❍`는 쓰지 않는다. 번호 체계(위 표의 4단계
`1.`→`가.`→`1)`→`가)`)와는 별개 축으로, **구조 번호 + 본문 기호**를 함께 쓴다.

마크다운 소스에서 각 단을 어떻게 적는지, 명사형 종결 등 문장 규칙은 `gaejosik` 스킬 소관.
작업공간에 별도 서식 SSOT가 있으면 그것이 우선한다.

| 소스 | 렌더(HTML) | md2docx `--gaejosik` | hwpx (hwp-cli) |
|------|-----------|----------------------|----------------|
| `□ 내용` 단락 | 개별 `<p>` | 글리프 유지 + 내어쓰기(1단) | 글리프 유지 + margin 0 |
| `  ○ 내용` 단락 | 개별 `<p>` | 글리프 유지 + 들여쓰기 1단 | 1단 margin |
| `- ` 리스트 L1 | `<li>` | 불릿 텍스트 `-` | BULLET `-` |
| `  - ` 리스트 L2+ | 중첩 `<li>` | 불릿 텍스트 `·` | BULLET `·` |
| 제목 리터럴 번호 | 그대로 | 그대로(자동 번호 없음) | 자동 번호 생략(이중 번호 가드) |

hwpx 열의 불릿 사다리는 **목표 계약**이다. 현재 릴리스 동작은 §5의 「현재 마커 동작」 참조.

단일 줄바꿈은 렌더러·md2docx에서 공백으로 합쳐지고 hwp-cli에서는 문단으로 쪼개지므로,
`□`·`○` 줄은 앞뒤에 빈 줄을 두어 독립 단락으로 만들고 세부는 마크다운 리스트로 적는다.

## 1. 보기 좋은 문서 생성 (`styled`) — 권장 기본 경로

사용자가 공문서·결재문서·사업계획서·보고서를 "**만들어달라**"고 요청할 때의 기본 명령. `docx` 스킬처럼 폰트·여백·줄간격·헤더/푸터·페이지번호가 설정된 완성형 HWPX를 생성한다.

### 1-A. 양식 파일이 주어진 경우 (`--reference`)

사업 공고에 첨부된 HWP 양식(예: `2026_사업계획서_양식.hwpx`)이 있으면 그 **양식의 폰트·여백·스타일을 그대로 물려받아** 본문만 채운다. 가장 안전한 경로.

```bash
./hwpx styled \
  --reference 2026_사업계획서_양식.hwpx \
  --markdown 사업계획.md \
  --footer "- # / ## -" \
  -o 최종_사업계획서.hwpx
```

양식이 `.hwp` (바이너리)이면 먼저 Hancom Office에서 열어 `.hwpx`로 저장해달라 요청하거나, `hwp convert 양식.hwp -o 양식.hwpx --to hwpx`로 변환 후 사용.

### 1-B. 양식이 없는 경우 (`styled`)

양식 파일이 없으면 `styled --markdown`으로 생성한다. hwp-cli `new --preset`으로 문서 기본 스타일을 만든 뒤 공문서 style_pass 후처리(표 칼럼 폭 비례, 헤더행 음영, 제목 가운데)를 적용한다.

```bash
./hwpx styled --preset gongmun --markdown 기안문.md \
  --header "예시대학교 AI학과" \
  --footer "- # / ## -" \
  -o out.hwpx
```

- `gongmun`과 `gian`은 hwp-cli의 `gian` 프리셋(기안문·공문), `bogoseo`와 `report`는 `report` 프리셋(보고서·사업계획서)에 매핑됨.
- `--plain`은 style_pass 후처리만 생략하며 preset은 그대로 적용됨.
- `--reference` 경로는 참조 양식을 보존하므로 preset을 적용하지 않음.
- preset 생성에는 `hwp new --preset` 지원 바이너리(hwp-cli v0.4.1 이상)가 필요함. 자동 탐색은 지원 바이너리 중 최고 버전을 선택하며, `HWP_CLI` 명시 지정본이 미지원이면 다른 설치본으로 조용히 우회하지 않고 갱신 방법을 안내함.

### 입력 markdown 규칙

단순한 문법을 지원한다:

```
# 대제목            → 가운데 정렬, bold, 큰 글씨
## 소제목 (H1)       → 좌측 정렬, bold
### 작은제목 (H2)    → 좌측 정렬, bold, 본문보다 약간 큼
---                  → 빈 줄 (구분선)
(빈 줄)              → 구분선
기타 모든 줄         → 본문 단락 (들여쓰기 유지 → 4단계 번호 그대로 표현)
```

예시 (보고서):

```markdown
# 2026학년도 AI 교육센터 운영계획

## I. 추진 배경
1. 제주 regional innovation 체계 전환에 따른 대학 역할 재정립 필요함
2. international cooperation-TIU 사업과 연계로 글로벌 확장성 확보 가능함

## II. 주요 추진 내용
1. 교과목 개편
  가. AI 기초·심화 커리큘럼 재설계함
  나. 산업 실무 프로젝트 통합함

붙임  1. 운영계획 상세(안) 1부.  끝.
```

### 머리글 / 바닥글 (header / footer)

- `--header "텍스트"` — 상단 머리글 (가운데 정렬)
- `--footer "템플릿"` — 하단 바닥글. `#`는 현재 쪽, `##`는 전체 쪽수 placeholder
- 기본 footer: `- # / ## -` (예: "- 1 / 3 -")
- footer 끄기: `--footer ""`

**페이지 번호 동작**: `#` / `##`는 플레이스홀더다. Hancom Office에서 파일을 연 후 **삽입 → 쪽 번호** 메뉴로 변환하면 자동 갱신된다. LibreOffice+H2Orestart로 렌더하면 리터럴 "#" / "##"로 표시되므로 PDF 변환 전에는 Hancom에서 한 번 열어 변환을 권장.

### JSON 입력

markdown 대신 구조화된 JSON으로 넘기려면:

```bash
cat > plan.json <<'EOF'
{
  "title": "2026 사업계획서",
  "subtitle": "제주 regional innovation AI 인재양성",
  "blocks": [
    {"kind": "heading", "text": "I. 사업 개요", "level": 1},
    {"kind": "para", "text": "1. 사업명: ..."},
    {"kind": "separator"},
    {"kind": "heading", "text": "II. 추진 배경", "level": 1},
    {"kind": "para", "text": "가. 제주 지역 AI 인재 수급 미스매치 해소 필요함"}
  ]
}
EOF
./hwpx styled --preset bogoseo --json plan.json -o plan.hwpx
```

stdin으로도 가능: `... | ./hwpx styled --preset gongmun --stdin-json -o out.hwpx`

### 폰트 커스터마이징 / 기관 양식 준수

프리셋 폰트가 기관 요건에 맞지 않으면 두 가지 경로:

1. **양식 따라가기** (권장): 기관의 정식 양식 `.hwpx`에 `{{본문}}`, `{{제목}}` 같은 slot을 넣고 `--reference`로 넘김
2. **생성 후 수정**: Hancom Office에서 열어 `서식 → 글자 모양`으로 수정

현재 hwp-cli `new` 생성 경로는 단락 중심 MVP다. 정교한 표·이미지·기관별 폰트/여백은 기관 양식 파일을 기준으로 slot 치환하거나 Hancom Office에서 최종 검수한다.

## 2. 템플릿 채우기 (`fill`)

### 기본 템플릿

| 파일 | 용도 |
|------|------|
| `templates/공문서_기본.hwpx` | 대외시행 공문 기본형 (수신/경유/제목/본문/붙임/발신명의) |
| `templates/기안문_내부결재.hwpx` | 내부결재 (결재란 자리 표시 + 기안자/협조자/시행번호) |
| `templates/기안문_대외시행.hwpx` | 대외시행 공문 (수신자 + 관인 자리 + 접수번호) |
| `templates/보고서_일반.hwpx` | 휴먼명조/개조식 보고서 (배경/내용/계획/행정사항) |
| `templates/사업계획서_기본.hwpx` | 9-section skeleton (개요/배경/목표/세부내용/일정/예산/효과/지표/붙임) |
| `templates/회의록.hwpx` | 참석자/안건/논의/결정사항/후속조치/차기회의 |

> `templates/사업계획서_기본.hwpx`의 대항목 번호는 ASCII `I./II./III.`로 되어 있으나, 제출용
> 한국어 공식 문서는 전각 로마자 `Ⅰ./Ⅱ./Ⅲ.`(U+2160 계열)를 쓴다. 템플릿 재생성은 별도
> 후속 과제이며, 이 템플릿으로 제출본을 만들 때는 해당 번호를 전각으로 바꿔 채운다.

### 공통 maru 명

모든 템플릿이 공유하는 placeholder (없는 템플릿은 무시됨):

```
{{기관명}} {{수신}} {{경유}} {{제목}} {{본문}} {{붙임}} {{발신명의}}
{{기안자}} {{기안자직위}} {{검토자}} {{협조자}} {{결재자}}
{{시행번호}} {{시행일자}} {{접수번호}} {{접수일자}}
{{주소}} {{홈페이지}} {{전화}} {{팩스}} {{이메일}} {{공개구분}}
```

템플릿별 추가 maru는 템플릿 자체를 `./hwpx read`로 확인.

### 사용 예

**방법 1 — `--kv` 플래그 (간단한 경우)**:
```bash
./hwpx fill templates/기안문_내부결재.hwpx \
  --kv 기관명="예시대학교" \
  --kv 제목="AI 교육센터 운영계획(안)" \
  --kv 본문="1. 목적
  가. 2026학년도 AI 교육센터 운영 방향 확립함
2. 추진계획
  가. 상반기 교과목 개편함" \
  --kv 붙임="운영계획 상세(안) 1부" \
  --kv 발신명의="AI학과장" \
  -o /tmp/gianmun.hwpx
```

**방법 2 — JSON 파일**:
```bash
cat > data.json <<'EOF'
{
  "기관명": "예시대학교",
  "제목": "…",
  "본문": "1. 목적\n  가. …",
  "붙임": "…",
  "발신명의": "AI학과장"
}
EOF
./hwpx fill templates/기안문_내부결재.hwpx --data data.json -o out.hwpx
```

**방법 3 — stdin JSON (다른 도구와 파이프)**:
```bash
echo '{"제목":"테스트","본문":"본문"}' | \
  ./hwpx fill templates/공문서_기본.hwpx --stdin-json -o out.hwpx
```

출력 문서는 반드시 `./hwpx validate` 통과시킬 것.

## 3. 읽기와 분석

```bash
./hwpx read report.hwpx              # markdown (기본)
./hwpx read report.hwpx --format text
./hwpx read report.hwpx --format json  # 섹션/단락/이미지 구조화
./hwpx summary report.hwpx            # 메타데이터 요약
./hwpx to-md report.hwpx -o out.md    # markdown 파일로 저장 (이미지 → out.media/ 추출)
./hwpx to-md report.hwpx -o out.md --media-dir figs  # 이미지를 figs/에 추출, figs/imageN.png 링크
```

읽기 플래그(`--with-header-footer`·`--with-hidden`·`--preview`, `convert --to md`의 대응
플래그)의 정본은 `hwp cat --help`다(§업스트림 경계). 워크스페이스에서 따로 기억할 것은
하나뿐이다:

```bash
hwp cat report.hwpx --format markdown --with-segments   # md + 추출근거 좌표
```

`--with-segments`는 markdown 전용으로, 각 출력 문자 범위가 어느 원본 문단(`section`/`para`
IR 인덱스)에서 왔는지를 한 줄 JSON 봉투로 낸다. 오프셋이 유니코드 스칼라 단위라
`markdown[start:end]`로 그대로 잘린다. `inbox-process`의 "verbatim 인용 + 원본 좌표"
추적이 이 계약에 의존한다.

`to-md -o`는 hwp-cli `convert` 위임이라 목록·각주·수식·병합셀(HTML 표 폴백)·글자효과까지
보존하고 이미지를 사이드카 디렉터리에 추출한다. stdout 출력(`-o` 생략)은 이미지 추출 없는
`cat` 경로(빈 참조 `![image]()`).

`inbox-process` 추출 단계에서 이 명령으로 `.hwpx` 내용 추출에 사용된다.

## 4. 편집

### 단순 find/replace (run-aware)

```bash
./hwpx edit input.hwpx output.hwpx --replace "OLD" "NEW"
./hwpx edit input.hwpx output.hwpx --replace "구버전" "신버전" --limit 1
```

lxml 엔진이 `<hp:t>` 텍스트를 연결해 치환하므로 **run 경계를 넘나드는 텍스트도 매칭**되고, 수정 단락의 `linesegarray`는 자동 정리된다(이전의 "한 run으로 저장" 제약 해소).

> **바이트 보존이 최우선인 단순 치환**에는 hwp-cli 고속 경로도 있다:
> `hwp edit in.hwpx -o out.hwpx --replace "구=>신"` (치환만 있을 때) — 미리보기·`hp:switch`
> 호환 블록·미모델 엔트리를 **바이트 그대로** 보존한다. 단 `<hp:t>` 런 분절을 가로지르는
> 문자열은 매칭되지 않으므로, 분할 가능성이 있으면 위 lxml `edit`을 쓴다.

### 표 행/열 추가 (hwp-cli 위임)

```bash
./hwpx add-rows 양식.hwpx --table 0 --count 2 --set-cell "0:5:0=값" -o out.hwpx
./hwpx add-col  양식.hwpx --table 0 --set-cell "0:0:2=비고" -o out.hwpx
```

- `add-rows` — 마지막의 병합 없는(clean) 행을 복제해 빈 행을 붙인다. `--set-cell`은
  2차 패스로 새 행/열을 채운다(구조 편집이 먼저 적용된 뒤라 같은 호출로는 못 채움).
- `add-col` — **전체 표 폭을 유지**한다: 새 열은 균등 몫(행총폭/(열수+1)), 기존 열은 비율
  축소, 행별 정수 잔차는 마지막 기존 셀에 가산. 새 열 인덱스 = 기존 열 수.
- **표 인덱스는 재귀 깊이 우선**(중첩 표 포함, `set-cell`과 동일 기준).
- **병합 셀 표 지원**: 행/열 추가·삭제, 셀 병합/분할 모두 병합 셀이 있는 표에서 동작한다
  (v0.2.0 열 연산 → v0.8.5 행 추가까지 확대). 유일한 예외는 **행 삭제**(`--delete-row`)로,
  병합 행을 거부한다.
- 래퍼의 `--template-row`는 여전히 무시된다(항상 마지막 clean 행 복제). 스타일 원본 행을
  고르려면 네이티브를 직접 부른다 — `hwp edit <in> -o <out> --add-row "표:위치:개수:템플릿행"`
  (v0.8.5+). 템플릿 행은 행 높이와 셀/문단/글자 서식만 물려주고 텍스트는 복사하지 않는다.
- 행/열의 **위치 삽입**, 삭제, 셀 병합/분할 등 세밀한 표 편집은 아래 "구조 편집 프리미티브".

### 구조 편집 프리미티브 (`hwp edit` 네이티브)

`hwp edit`은 `.hwp`·`.hwpx` 모두에서 **바이트 보존**(미리보기·`hp:switch` 호환 블록·미모델
엔트리 그대로)하며 IR 왕복으로 편집한다. 앵커는 텍스트 매칭이고, 여러 플래그를 한 호출에
조합할 수 있다. 적용 후 `--verify`로 재읽기 검증(`검증: 재읽기 OK`).

**플래그 정본은 `hwp edit --help`**(31종). 공문서 작업에서 실제로 쓰는 것만 여기 남긴다:

```bash
# 누름틀(필드) 생성·채우기 — 결재란·수신 양식
hwp edit in.hwpx -o out.hwpx --create-field "수신=>수신자명" --set-field "수신자명=예시대학교"

# 표 구조 편집 (0-기반, 반복 가능, 병합 셀 표 지원)
hwp edit in.hwpx -o out.hwpx --add-row "0:1:2"        # 표0 1행 앞에 2행 삽입(생략·"end"는 끝에 추가)
hwp edit in.hwpx -o out.hwpx --add-col "0:1"          # 표0 1번 위치에 열 삽입(전체 폭 유지)
hwp edit in.hwpx -o out.hwpx --merge-cells "0:0:0:0:2" --split-cell "0:1:0"

# 메타데이터 — 생성 시점(new) 또는 기존 문서(edit) 모두, 키: title/author/subject/keywords
hwp edit doc.hwpx -o doc.hwpx --set-meta "subject=AI교육센터" --set-meta "keywords=AI,교육"
```

- 이 프리미티브들은 순수 hwp-cli라 `./hwpx` 래퍼가 아니라 **PATH의 `hwp`를 직접 호출**한다.
  run 경계를 넘나드는 find/replace가 필요하면 lxml 경로 `./hwpx edit`을 쓴다.
- 이미지 삽입·문단 정렬/서식·문단 삽입/삭제·페이지 설정·표 복제(`--clone-table`) 등 나머지
  플래그는 upstream 스킬과 `hwp edit --help`가 정본이다(§업스트림 경계).
### 도장 날인 (`hwp edit --seal`)

앵커 텍스트(전형적으로 `(인)`) 위에 이미지를 부유(floating) 배치한다. hwpx·hwp 출력 모두 지원.

```bash
hwp edit 결재.hwpx -o 날인.hwpx --seal "(인)=>seal.png"          # 기본 20mm
hwp edit 결재.hwpx -o 날인.hwpx --seal "(인)=>seal.png@18mm"     # 크기 지정
```

> **주의**: 전자결재 문서의 관인(직인)은 e-결재 시스템(온나라 등)이 발송 시 자동 삽입한다 —
> 이 스킬이 생성하는 문서에는 넣지 않는다(응답 원칙 #5). `--seal`은 출력·전송용 문서에
> 명시적으로 도장 이미지가 필요한 경우(납품용 인쇄본 등)에만 사용한다.

### 레퍼런스 양식 편집 워크플로우 (권장)

첨부된 임의 공문 양식의 서식·구조를 보존하며 본문만 교체:

```bash
# 1) 청사진: sec 직계자식 인덱스 + 스타일 ID 확인 (텍스트가 아닌 인덱스로 경계 파악)
./hwpx analyze 양식.hwpx

# 2a) 앵커가 있으면 fill (run-aware)
./hwpx fill 양식.hwpx --kv 제목="…" --kv 본문="…" -o 결과.hwpx
# 2b) 본문 단락 블록을 통째 교체하려면 edit-section (analyze 인덱스 사용, 서식 복제)
./hwpx edit-section 양식.hwpx --start 12 --end 18 --ref-index 12 --lines body.txt -o 결과.hwpx

# 3) 무결성 검증
./hwpx validate 결과.hwpx

# 4) 보존 게이트 (필수) — 문단/표/명시적 쪽나눔·텍스트길이 드리프트 검사(구조 기준, 렌더 안 함)
./hwpx guard --reference 양식.hwpx --output 결과.hwpx
```

`guard`가 FAIL이면(문단 수 변동, 텍스트 길이 과다 등) 완료로 보지 않고 본문을 압축/조정 후 재빌드한다. 여러 본문 블록을 교체할 때는 **마지막 섹션부터 역순**으로 `edit-section`을 호출해 인덱스 어긋남을 방지한다(엔진 `replace_section_body`도 동일 전제). 복잡한 in-place 편집은 `analyze` 결과를 보고 `scripts/hwpx_xml.py`의 `clone_para`/`replace_section_body`/`replace_in_paragraph`를 인라인 Python으로 직접 호출할 수 있다.

### unpack → XML 직접 편집 → repack

복잡한 구조 변경(표 행 추가, 스타일 변경 등)에 사용:

```bash
./hwpx unpack input.hwpx workdir/
# 이 단계에서 Edit 도구로 workdir/Contents/section0.xml 등을 직접 수정
./hwpx repack workdir/ output.hwpx
./hwpx validate output.hwpx
```

**주의**:
- `mimetype`은 zip의 **첫 번째 엔트리**이며 **STORED(무압축)**이어야 한다. `repack` 커맨드는 이를 자동 보장한다. 수동 zip 사용 금지.
- `Contents/content.hpf`에 나열되지 않은 새 파일 추가 시 manifest도 함께 갱신해야 한다.

상세는 `references/hwpx-structure.md`, `references/raw-zip-fallback.md`.

## 5. 단순 신규 생성 (`create`)

```bash
./hwpx create out.hwpx --title "제목" --body "한 줄\n다른 줄"
./hwpx create out.hwpx --markdown input.md
./hwpx create out.hwpx --json '{"title": "...", "paragraphs": ["1", "2"]}'
```

**스타일 사다리(보고서 형식)**: `hwp new --from md`는 제목에 절 번호를 붙이고 목록을
**네이티브 번호/글머리 문단**으로 생성한다. H1~H3 절 번호(`1.`/`1-1.`/`1-1-1.` 리터럴 접두,
숫자로 시작하는 제목은 이중 번호 방지로 생략), 번호 목록은 네이티브 NUMBER(시작 번호 인정),
불릿은 네이티브 BULLET(수준별 들여쓰기). `cat` 평문에는 마커가 안 보이는 게 정상(자동 번호)
이고, markdown 출력(`to-md`)과 한글 화면에는 합성되어 표시된다.

**현재 마커 동작** (릴리스 v0.8.6 실측):
- 불릿은 개조식 사다리대로 나온다 — **1수준 `-`, 2수준 이하 `·`**(생성물 `hh:bullet` 정의
  확인). 위 「개조식 기호 사다리」의 목표 계약이 반영됐다.
- 번호 목록은 **수준별로 형식이 달라지지 않는다**. hwpx 쓰기가 수준 K마다 `^K.` 템플릿을
  채우므로 1·2·3수준 모두 `1.` 꼴로 표시된다(`1.`→`1)` 사다리가 아님). 4단계 번호 체계가
  필요한 공문서는 마크다운 소스에 번호를 리터럴로 적는다.

**현재 한계**:
- 복잡한 헤더/푸터(다단·이미지 머리말 등)는 미지원 — raw ZIP/XML 편집 또는 Hancom Office
  기반 양식 보정이 필요하다. (markdown `[^n]` 각주는 이제 `hp:footNote`로 들여온다 — 아래 참조.)
- 병합 표·기관별 폰트/여백 조정이 필요한 복잡한 공문서는 템플릿 채우기 또는
  레퍼런스 양식 편집(§4) 경로를 쓸 것.

**지원되는 본문 요소**: `![alt](경로)` 이미지 들여오기(png/jpg/bmp/gif — 파일을 읽어
본문 크기에 맞춰 삽입), `[^n]` 각주(한글 저장본 동형 `hp:footNote`로 들여옴),
`` `인라인 코드` ``(모노스페이스 글자 모양), 취소선(`~~`), GFM 표·개조식 리스트(위 사다리).

## 5-A. 문서 생성 (`create`, `styled`, `write-java`)

문서 생성은 모두 **hwp-cli `new`**에 위임한다 (번들 Java writer·JRE 제거됨).

- `create` / `write-java` — markdown(또는 title/body/JSON 블록)을 받아 `hwp new --from`으로 HWPX 생성. `write-java`는 레거시 별칭(앵커 export 폴백 계약 유지, 더 이상 Java 미사용).
- **문서 메타데이터**: `hwp new`는 `--set-meta "키=값"`(키: `title`/`author`/`subject`/`keywords`, 반복 가능)으로 제목·작성자 등을 지정한다. 기존 문서는 `hwp edit --set-meta`로 갱신(§4).
- `styled --markdown <md> -o <out>` — `hwp new --preset` 생성 후 공문서 스타일 후처리. `gongmun|gian`은 `gian`, `bogoseo|report`는 `report`로 전달. `--plain`은 후처리만 생략.
- `styled --reference <양식> ...` — 참조 템플릿의 `{{슬롯}}`을 lxml 엔진(`hwpx_xml.edit_text`)으로 채움(충실도 보존).
- **공문서 스타일 후처리(`style_pass.py`)** — 템플릿 없는 생성 전 경로에 자동. 표: 칼럼 폭 내용 비례(2col 라벨:값 1:3~1:4, 좁은 칼럼 최소 12mm, 균등 내용은 균등 유지, 총폭 보존), 헤더행 음영 #F2F2F2+굵게+가운데, 짧은 칼럼(표시폭≤8) 본문 셀 가운데; 제목 H1 가운데 15pt 굵게. `--plain` 생략, 기존 파일은 `beautify` (`--header-fill`, `--no-title-center`). 멱등·이미 스타일된 표 불가침(균등 폭 아님/borderFill 혼합 시 스킵). 패턴 근거: `references/style-patterns.md` (workspace 실문서 137건 분석).

```bash
./hwpx create out.hwpx --title "제목" --body "본문"
./hwpx write-java out.hwpx --markdown report.md
./hwpx styled --preset bogoseo --markdown report.md -o out.hwpx
```

`export-html`(HTML→HWPX)은 소비자가 없어 제거됨. PDF/HTML 출력은 §1·§7의 hwp-cli 네이티브 경로 사용.

## 6. OWPML 핵심 요소

| 요소 | 위치 | 역할 |
|------|------|------|
| `<hp:sec>` | `Contents/sectionN.xml` | 섹션 (페이지 설정 + 단락 흐름) |
| `<hp:p>` | section 내부 | 단락. `paraPrIDRef`로 paraPr 참조 |
| `<hp:run>` | 단락 내부 | 런(문자 속성 단위). `charPrIDRef`로 charPr 참조 |
| `<hp:t>` | run 내부 | 실제 텍스트 |
| `<hp:tbl>` / `<hp:tr>` / `<hp:tc>` | block-level | 표/행/셀 |
| `<hp:pic>` | block-level | 이미지 (BinData/<id>.<ext> 참조) |
| `<hh:charPr>`, `<hh:paraPr>`, `<hh:style>` | `Contents/header.xml` | 스타일 딕셔너리 (ID 기반 참조) |

상세는 `references/owpml-quickref.md`.

## 7. 변환과 렌더링

### PDF

`to-pdf`는 기본적으로 **hwp-cli 네이티브**로 변환한다 (DisplayList → `pdf-writer`,
CIDFont(Identity-H) + ToUnicode). **텍스트 선택·검색 가능**, 레이아웃 정확, LibreOffice 불필요.
**사용 글리프만 폰트 서브셋 임베드**(파일 작음) + **본문 이미지 임베드**(JPEG 통과 /
PNG·BMP·GIF 디코드). 그리기 개체(도형), **본문 다단**, **수식**(자동 조판)도 렌더한다.
단, 글상자 다단·양쪽정렬·차트·OLE 등은 근사 또는 미지원이므로 결과 기대치는 `references/capability-matrix.md`를 참조한다.

```bash
./hwpx to-pdf document.hwpx -o document.pdf            # 기본: hwp-cli (선택가능)
./hwpx to-pdf document.hwpx --engine hwp               # hwp-cli 강제
./hwpx to-pdf document.hwpx --engine soffice           # LibreOffice 폴백 (벡터)
```

- `--engine auto`(기본): hwp-cli 네이티브 우선, 미발견/실패 시 soffice 폴백.
- `--engine hwp`: hwp-cli 강제. `render-pdf`와 동일.
- `--engine soffice`: LibreOffice 경로. **H2Orestart 확장** 필요:

```bash
brew install --cask libreoffice
# H2Orestart: https://extensions.libreoffice.org/en/extensions/show/27504
# 다운로드 후 LibreOffice → 도구 → 확장 관리자 → 추가
```

(`render-pdf`는 `to-pdf --engine hwp`와 동일한 하위호환 별칭.)

### 레거시 `.hwp` (바이너리)

이 스킬은 HWPX 작성·편집 전용이나, **`./hwpx read legacy.hwp`는 자동으로 `hwp-cli`(`hwp cat`)에 위임**하여 텍스트를 추출한다 (탐색 순서: `$HWP_CLI` → `~/.cargo/bin/hwp` → `~/workspace/work/dev/hwp-cli/target/release/hwp` → 검증된 PATH의 `hwp`). 변환·렌더·PDF도 hwp-cli 경유:

```bash
./hwpx read legacy.hwp                              # → hwp-cli 자동 위임 (텍스트 추출)
./hwpx render-pdf legacy.hwp -o legacy.pdf          # 텍스트 선택가능 PDF (hwp-cli 네이티브, to-pdf --engine hwp 별칭)
./hwpx to-html legacy.hwp -o legacy.html            # markdown 수준 HTML
hwp convert legacy.hwp -o legacy.hwpx --to hwpx     # .hwp → .hwpx (직접 hwp-cli)
hwp edit legacy.hwp -o out.hwp --replace "구=>신"    # .hwp 직접 편집(hwp-cli만 가능)
```

### 폰트와 수식

- **`--font-dir <경로>`**(반복 가능)는 `render`·`diff`와 `convert`의 PDF 경로가 받는다.
  미지정 시 `HWP_FONT_DIR`(없으면 `fonts/`)로 해석하며, `./hwpx` 래퍼는 `~/.maru/env/fonts`
  또는 `~/Library/Fonts`를 자동으로 넣어준다. CJK 글리프가 비거나 깨지면 이 플래그로 명시한다.
- **수식은 `render`·`to-pdf`에서 자동 조판**된다(별도 옵션·서브커맨드 없음). 수식을 새로 쓰는
  저작 CLI는 없다. hwpx 쓰기 보존은 **v0.3.0부터**로, 그 미만에서는 편집·변환만 해도 수식이
  경고 없이 통째로 사라진다. 지원 문법과 근사 한계는 `references/equation-syntax.md`.
- ⚠ 합성 경로(hwp5→hwpx 등 새로 만드는 `<hp:equation>`)의 수식 전용 상수는 정답지 미확보
  **표준 추정값**이다. 중요한 수식 문서는 한글에서 한 번 열어 확인할 것.
- `info`(hwp-cli 메타: 포맷·버전·스트림)와 `summary`(lxml 구조요약: 섹션·단락·이미지 수)는
  관점이 다르다. `render`는 이미지(png/svg) 미리보기용이고, 텍스트 선택가능 PDF는 `to-pdf`다.
## 8. 통합

- **inbox-process**: `.hwpx`·`.hwp` 모두 `./hwpx read <file>`로 내용 추출 — **hwp-cli(`hwp cat`)가 1순위 엔진**(.hwpx는 text/md에 우선 사용·실패 시 lxml 폴백, .hwp는 자동 위임). `read --format json`·`summary`는 구조 스키마 안정을 위해 lxml 유지. 공유 env 추출기(`extract_all.py`)도 1순위 엔진으로 hwp-cli 사용.
- **gaejosik 스킬**: 본문 생성 시 개조식 종결("~함", "~임") 적용. 이 스킬은 `--kv 본문="…"`으로 받은 텍스트를 그대로 치환만 한다.
- **io-mso 스킬**: 생성된 HWPX를 Microsoft 365 mail/share workflow로 전송.
- **meeting-notes 스킬**: 회의록 markdown → `./hwpx fill templates/회의록.hwpx` 경로 가능.

## 9. 자주 발생하는 실수

| 증상 | 원인 | 해결 |
|------|------|------|
| Hancom Office에서 파일 열리지 않음 | mimetype이 zip 첫 엔트리가 아니거나 DEFLATE | `./hwpx repack`으로 다시 묶기 (수동 `zip` 명령 금지) |
| `{{anchor}}` 치환이 0건 | anchor 철자/공백 불일치 (run 분할은 이제 엔진이 처리) | `./hwpx slots`로 실제 앵커명 확인 후 정확히 지정 |
| 채운 문서가 레퍼런스보다 쪽수 증가 | 본문이 원본 레이아웃 초과 | 실제 쪽수는 `hwp render --report`의 `total_pages`로 확인(guard는 렌더 안 함) → `./hwpx guard`로 문단·텍스트 길이 드리프트 확인 → 본문 압축/조정 후 재빌드 |
| 한글이 깨짐 | 생성 시 인코딩 | 입력 JSON/텍스트 UTF-8 확인 |
| to-pdf `--engine soffice` 실패 | LibreOffice에 H2Orestart 미설치 | 확장 설치 후 `soffice --headless` 1회 실행으로 캐시 빌드. 또는 기본 엔진(hwp-cli, LibreOffice 불필요) 사용 |
| render-pdf 빈/깨진 페이지 | 함초롬(HCR) 등 CJK 폰트 미해결 | `HWP_FONT_DIR=<폰트 디렉토리>` 지정 (`~/.maru/env/fonts` 또는 `~/Library/Fonts`), 또는 `--font-dir` 플래그 (v0.3.0+는 `convert`도 지원) |
| **수식이 편집/변환 후 사라짐** | hwp-cli **0.3.0 미만** (hwpx writer 수식 arm 부재, 무경고 유실) | `brew upgrade hwp` 또는 `cargo install --path crates/hwp-cli --force`. `hwp --version`으로 확인 |
| 새 hwp-cli를 설치했는데 신기능이 안 보임 | 다른 경로의 **오래된 사본**이 잡힘 | 스킬은 버전 최대를 자동 선택하고 구버전이면 경고한다. 직접 호출 시엔 `which -a hwp`로 중복 확인 후 `HWP_CLI=<원하는 빌드>` 지정 |
| 관인(직인)이 안 찍힘 | 스킬은 관인 삽입 안 함 | 정상 동작 — e-결재 시스템(온나라/K-Office)이 발송 시 자동 삽입 |
| `.hwp` 파일 읽기 | 바이너리 HWP | `./hwpx read`가 hwp-cli(`hwp cat`)에 자동 위임 (미발견 시 `brew tap staixbwlb/hwp https://github.com/STAIxBWLB/hwp-cli && brew install hwp` 또는 `HWP_CLI` 지정). HWPX 작성·편집은 이 스킬 전용 |

## 10. 의존성

- **Python**: 공유 venv 또는 system `python3`
  - `lxml` — 슬롯/구조 편집 엔진 (fill-form·edit-section·analyze·guard·styled --reference)
- **hwp-cli** (`hwp`): 생성·변환·렌더·검증의 1순위 엔진. **최소 요구 v0.3.0**
  (그 미만은 hwpx 쓰기에서 수식이 조용히 유실된다. §7 「폰트와 수식」 참조).

  설치·갱신:

  ```bash
  brew tap staixbwlb/hwp https://github.com/STAIxBWLB/hwp-cli   # 저장소 자체가 tap
  brew install hwp                                              # 릴리스판 (권장)
  brew upgrade hwp                                              # 갱신
  # 또는 워크스페이스 현재 브랜치의 미릴리스 신기능이 필요할 때:
  cd ~/workspace/work/dev/hwp-cli && cargo install --path crates/hwp-cli --force
  ```

  **탐색 규칙**: `$HWP_CLI`가 지정되면 그것을 쓰고(명시적 의도 우선), 없으면 PATH(brew 등)·
  `~/.cargo/bin/hwp`·`dev/hwp-cli/target/release/hwp` 중 **버전이 가장 높은 것**을 고른다.
  고정 순서가 아닌 이유는 세 곳에 동시에 설치되는 게 정상이라(brew + cargo + dev 빌드)
  고정 순서면 오래된 사본이 먼저 잡혀 신기능이 조용히 안 보이기 때문이다.
  구버전이 잡히면 stderr에 경고를 낸다. 특정 빌드를 강제하려면 `HWP_CLI=<...>/hwp`.

  **CLI 표면 정본**은 §업스트림 경계 참조.

  **업스트림 동기화**: 이 스킬이 검증된 hwp-cli 릴리스는 `upstream.json`의
  `verified_release`에 기록한다. `.github/workflows/upstream-hwp-cli.yml`이 매일 최신 릴리스와
  비교해 어긋나면 `upstream` 라벨로 이슈를 연다(알림만 하고 CI는 막지 않는다). 스킬을 새 릴리스에
  맞춘 PR에서 `verified_release`를 함께 올려야 알림이 멎는다.
- **선택**: LibreOffice + H2Orestart 확장 (`to-pdf --engine soffice` 벡터 PDF용; 기본 hwp-cli 경로엔 불필요)
- **선택**: Hancom Office 한/글 (템플릿 편집/검수용)

CLI 진입점은 `./hwpx` 래퍼가 자동으로 venv python을 사용한다.

## 11. 참고 문서

- `references/hwpx-structure.md` — zip 레이아웃, mimetype 규칙, 네임스페이스 표
- `references/owpml-quickref.md` — 주요 OWPML 요소 빠른 참조
- `references/korean-official-format.md` — 행정효율규정 기안문 구조 상세
- `references/raw-zip-fallback.md` — zipfile+lxml로 직접 다루기
- `references/library-landscape.md` — raw ZIP/XML / hwpxlib / pyhwpx / pyhwp 비교
- `references/equation-syntax.md` — 수식(mini-TeX) 지원 문법·근사 한계
- `references/capability-matrix.md` — hwp-cli 렌더/변환 결과 기대치 (doc12 기반, v0.8.6 확인)
- upstream `skills/hwp` (`hwp skill export`) — 일반 CLI·MCP 표면 정본 (§업스트림 경계)

## 응답 원칙

1. 한국어 소통
2. 공문서 규정 준수 — 여백·폰트·줄간격·번호체계·"끝." 표기
3. 템플릿 있으면 템플릿 채우기 우선, 없으면 신규 생성 경로
4. 생성 직후 반드시 `./hwpx validate` 실행
5. 관인·결재란은 절대 이미지로 삽입하지 않음 (e-결재 시스템 담당)
6. 개조식 본문 필요 시 `gaejosik` 스킬 먼저 호출하여 텍스트 생성 후 fill
