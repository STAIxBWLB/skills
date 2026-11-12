# Document Runtime Reference

`envs/default/` is the source scaffold for the shared Python/Node runtime used
by document and graph skills. `setup.sh --target ~/.maru/env` provisions it
into the canonical runtime `~/.maru/env`. This file is the source of truth for
the layout, env resolution, provisioning and session hook; other files point
here.

## Layout

```text
envs/default/
├── pyproject.toml        # Python dependencies managed by uv
├── uv.lock
├── package.json          # Node dependencies managed by pnpm
├── pnpm-lock.yaml
├── setup.sh              # provision or --verify a runtime target
├── Makefile              # dev-in-tree commands (make help)
├── .claude/
│   ├── hooks/init-env.sh         # SessionStart hook
│   ├── templates/settings.json   # hook registration template
│   └── settings.json
└── scripts/
    ├── extract_all.py            # HWP/HWPX/PDF text extraction
    ├── check_extract_engine_error.py  # self-check for the engine-missing path
    ├── extract_pdf.py
    ├── ocr_pipeline.py
    ├── infuse-hooks.sh           # copy the hook into workspace submodules
    ├── setup-node.sh
    └── utils/file_detector.py
```

Tracked: the scaffold above, with `pyproject.toml`, `uv.lock`, `package.json`
and `pnpm-lock.yaml` as the dependency source of truth. Runtime outputs are
ignored: `.venv/`, `node/`, `node_modules/`, `input/`, `output/`, `temp/` and
`logs/`.

## Processing Strategy

- HWP v5: `libhwp` first, then `hwp5txt`, then direct OLE parsing if needed.
- HWPX: ZIP/XML parsing with `BeautifulSoup` and `lxml`.
- PDF: `pymupdf` for fast text extraction, `pdfplumber` for tables, OCR tools for scanned PDFs.
- HWPX writing: use the released agent-hwp binary (`ahwp`; `hwp` only on releases before `v1.6.0`) and its unified exported `hwp` skill tree (minimum `v1.2.0`); verify the selected absolute binary's version before generation, fill, or validation. No bundled JRE.

## Provisioning and verification

```bash
# Provision or repair the canonical runtime (venv + node_modules)
bash ~/.maru/skills/_builtin/envs/default/setup.sh --target ~/.maru/env

# Health-check it (no changes)
bash ~/.maru/skills/_builtin/envs/default/setup.sh --verify --target ~/.maru/env

# dev-in-tree: provision this directory, check system dependencies
make setup
make verify
```

## Env resolution (canonical)

Skill wrappers resolve the python interpreter in this order. **This is the
source of truth; keep the duplicated `find_env_python` copies in the wrappers in
sync with it**:

1. `$SKILL_PYTHON` (caller override)
2. `$MARU_SKILLS_ENV/.venv/bin/python3` (host-injected)
3. `$HOME/.maru/env/.venv/bin/python3` (canonical fixed location)
4. repo-local walk-up: `env/.venv`, `envs/default/.venv`, `skills/envs/default/.venv` (dev-in-tree)
5. system `python3` (warning)

Ambient `$VIRTUAL_ENV` is intentionally ignored as an input so unrelated shell
venvs cannot shadow the Maru runtime. The Maru host injects `MARU_SKILLS_ENV`,
`VIRTUAL_ENV`, `PATH` (`+.venv/bin`), and `NODE_PATH` (`+node_modules`) for
in-app runs; the shell wrappers export the same set so bare CLI sessions match.

## Session hook

`.claude/hooks/init-env.sh` resolves the env (steps 2-4 above) and writes the
same four variables into `CLAUDE_ENV_FILE`, so later tool calls in the session
use the shared runtime. Register it as a SessionStart hook in the host's
settings, or run `scripts/infuse-hooks.sh --all` (`--dry-run` to preview) to
copy the hook and its settings template into workspace submodules.
