# STAI x BWLB Skills

> Public Claude Code skills catalog — document toolkits, Korean writing, slide deck prompts, and design system tools.

A curated collection of [Claude Code](https://claude.com/claude-code) **skills** that work on any machine without personal context. These skills are extracted from a private workspace and refactored to be reusable.

## What's a skill?

A skill is a packaged prompt + reference files + (optionally) helper scripts that Claude Code loads on demand. Each skill lives in `skills/<name>/SKILL.md` with optional `references/`, `scripts/`, and `templates/` subdirectories.

## Catalog

### Document toolkits
- **hwpx** — 한국 공문서·기안문 HWPX 작성·편집 (python-hwpx)
- **pptx-toolkit** — PowerPoint(.pptx) read·outline·notes 추출 (python-pptx)
- **xlsx-toolkit** — Excel(.xlsx) read·summary·markdown 변환 (openpyxl)

### Korean writing
- **gaejosik** — 한국어 개조식(명사형 종결) 공식 문서 글쓰기

### Slide deck prompts
- **canva-deck** — Canva Magic Design / AI 프레젠테이션 프롬프트 카탈로그
- **notebooklm-deck** — NotebookLM Slide Deck / Visual Overview 프롬프트
- **gpt-images-deck** — GPT 이미지 생성 덱 카탈로그

### Design system
- **design-init** — 새 프로젝트 디자인 방향 5단계 인터뷰 + scaffolding
- **design-motion** — CSS 애니메이션 패턴 카탈로그
- **design-system** — Tailwind v4 @theme 디자인 토큰 가이드
- **design-review** — `/polish`, `/audit`, `/distill`, `/roadmap` 코드 검수
- **design-a11y** — KWCAG 2.2 한국 웹접근성 검수

## Install

```bash
# Clone into your skills root (Claude Code reads ~/.claude/skills/)
git clone https://github.com/STAIxBWLB/skills.git ~/.claude/skills-staixbwlb

# Or selectively symlink individual skills
ln -s ~/.claude/skills-staixbwlb/skills/hwpx ~/.claude/skills/hwpx
```

Run `./install.sh` for guided installation.

## Vault dependencies

A few skills (notably the design family) reference a small markdown vault for tokens, glossary, and patterns. The vault is **opt-in** — see [`docs/vault-setup.md`](./docs/vault-setup.md) for a minimal setup, or skip it entirely if you only use the document-toolkit and slide-deck skills. Templates and bootstrap prompts live under [`docs/templates/`](./docs/templates/) and [`docs/prompts/`](./docs/prompts/). For knowledge-graph builds, see [`docs/graphify-usage.md`](./docs/graphify-usage.md).

The 12 skills here are mostly self-contained. Workspace-specific skills (vault sync, inbox processing, task management with personal credentials) live in private repos and are NOT part of this catalog.

## Contributing

Pull requests welcome — but **do not include** personal context (chu.ac.kr, named individuals, KOICA, RISE, specific institutions). Skills here must be generalizable. See `CONTRIBUTING.md`.

## License

MIT — see `LICENSE`.

## Origin

Maintained by [STAI × BWLB](https://staixbwlb.com), extracted from a research workspace at Jeju Halla University. Authored skills retain their original style; some have been refactored for portability.
