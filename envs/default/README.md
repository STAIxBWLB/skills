# 문서 처리 환경 (envs/default → ~/.maru/env)

HWP/HWPX/PDF 파일 처리를 위한 공유 Python 가상환경 + 번들 Node 런타임.
이 디렉토리(`envs/default`)는 source scaffold 이며, `setup.sh --target ~/.maru/env`
로 정규 런타임 `~/.maru/env`(`.venv` + `node` + `node_modules`)에 프로비저닝된다.
번들 Node(`node/`)는 md2docx(docx-js) 변환기를 시스템 node 의존 없이 실행한다.
Claude Code SessionStart hook(`init-env.sh`)이 세션에서 이 환경을 자동 활성화한다.

## 구조

디렉토리 구조, env 해소 순서, 프로비저닝, SessionStart hook의 정본은
[`REFERENCE.md`](REFERENCE.md)다. 에이전트 지시는 [`AGENTS.md`](AGENTS.md)에 있다.

## 설치된 패키지

| 카테고리 | 패키지 | 용도 |
|---------|--------|------|
| HWP | libhwp, pyhwp(hwp5), olefile, lxml | HWP v5 텍스트 추출, HWPX ZIP/XML 처리 |
| PDF | pymupdf, pymupdf4llm, pdfplumber, pdfminer-six | PDF 텍스트/표 추출 |
| OCR | pytesseract, pdf2image, ocrmypdf, pillow | 스캔 PDF OCR |
| 유틸 | click, tqdm, python-magic, chardet, beautifulsoup4, lxml, six | 파일 처리 보조 |
| Node | docx (`package.json`) | md2docx 스킬 docx-js 변환 (번들 `node/` 런타임으로 실행) |

## 사용법

프로비저닝·헬스체크 명령은 [`REFERENCE.md`](REFERENCE.md) "Provisioning and verification"을 따른다.
이 소스 디렉토리에서 직접 쓰는 명령(`make help`로 전체 목록):

```bash
make process-hwp    # input/hwp/ → output/text/
make process-pdf    # input/pdf/ → output/text/
make process-all    # input/ 전체
make ocr            # 스캔 PDF OCR
make sync           # pyproject.toml/package.json 변경 후 패키지 동기화
```

## 연관 도구

- **released agent-hwp**: Rust 단일 바이너리(`ahwp`, `v1.6.0` 이전 릴리스에서는 `hwp`) — `.hwp`/`.hwpx` 읽기·변환·렌더·편집. HWPX 작성에는 absolute released path와 minimum `v1.2.0`을 사용하고 `--version`으로 확인 (unversioned cargo/PATH binary는 release evidence 아님). `extract_all.py`가 1순위 추출 엔진으로 사용 (구 hwp-toolkit 대체)
- **unified hwp skill**: released binary가 export하는 `hwp` tree — HWPX 작성·편집과 공식 문서 레시피를 제공. 정확한 output contract는 `hwp/references/editing-recipes.md`와 `hwp/references/korean-official-format.md` 참조
- **md2docx 스킬**: `~/.maru/skills/md2docx` — markdown → 세련된 `.docx`(docx-js). 번들 `node/` 런타임 + `node_modules/docx` 사용 (pandoc 미사용)
- **skills**: `~/.maru/skills/` (federation; inbox-process 등이 이 환경에 의존)
