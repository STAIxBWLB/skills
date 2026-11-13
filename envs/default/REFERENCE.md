# Document Runtime Reference

`envs/default/` is the source scaffold for the shared Python/Node runtime used
by document and graph skills. Maru builds it into `~/.maru/env/<envHash>`;
without Maru, `setup.sh --target ~/.maru/env` provisions the legacy location. This file is the source of truth for
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
│   └── settings.json             # registers the hook when envs/default is the project
└── scripts/
    ├── extract_all.py            # HWP/HWPX/PDF text extraction
    ├── check_extract_engine_error.py  # self-check for the engine-missing path
    ├── check_active_env.sh       # self-check for the env resolution order
    ├── extract_pdf.py
    ├── ocr_pipeline.py
    ├── setup-node.sh
    └── utils/file_detector.py
```

`pyproject.toml`, `uv.lock`, `package.json` and `pnpm-lock.yaml` are the
dependency source of truth. Runtime outputs are ignored: `.venv/`, `node/`,
`node_modules/`, `input/`, `output/`, `temp/` and `logs/`.

## Processing Strategy

- HWP v5: `libhwp` first, then `hwp5txt`, then direct OLE parsing if needed.
- HWPX: ZIP/XML parsing with `BeautifulSoup` and `lxml`.
- PDF: `pymupdf` for fast text extraction, `pdfplumber` for tables, OCR tools for scanned PDFs.
- HWPX writing: use the released agent-hwp binary (`ahwp`; `hwp` only on releases before `v1.6.0`) and its unified exported `hwp` skill tree (minimum `v1.2.0`); verify the selected absolute binary's version before generation, fill, or validation. No bundled JRE.

## Provisioning and verification

```bash
# With Maru: Settings > Skills > Bootstrap rebuilds the active hashed env
# (venv, bundled node/, node_modules). The CLI builds it only while applying a
# newer bundle (`maru skills update --apply --repair-env`).

# Without the Maru app, and only when there is no active hashed env (no
# recorded active.envHash whose directory exists under ~/.maru/env; while that
# directory exists the wrappers never use the legacy location): provision or
# health-check ~/.maru/env, from the bundle (~/.maru/skills/_builtin/envs/default/)
# or this directory in a checkout
bash setup.sh --target ~/.maru/env
bash setup.sh --verify --target ~/.maru/env

# dev-in-tree: provision this directory, check system dependencies
make setup
make verify

# resolution self-check: runs the wrappers and the hook against a fake home
bash scripts/check_active_env.sh
```

## Env resolution (canonical)

Skill wrappers resolve the python interpreter in this order. **This is the
source of truth; keep the duplicated `find_env_python` copies in the wrappers in
sync with it**:

1. `$SKILL_PYTHON` (caller override)
2. `$MARU_SKILLS_ENV/.venv/bin/python3` (host-injected)
3. `$HOME/.maru/env/<hash>/.venv/bin/python3`, the active hashed env: `<hash>` is
   `active.envHash` in `~/.maru/skills/bundle-state.json`, used whenever that
   directory exists, built or not, as Maru's `env_root()` does
   (`maru_active_env` in each wrapper)
4. `$HOME/.maru/env/.venv/bin/python3`, the legacy location, only when there is
   no active hashed env
5. repo-local walk-up: `env/.venv`, `envs/default/.venv`, `skills/envs/default/.venv` (dev-in-tree);
   it stops at `~/.maru`, so it never reaches the legacy env
6. system `python3` (warning)

The md2docx wrapper resolves `node/bin/node` in the same order, with `$SKILL_NODE` as the override; when it falls back to system node it still sets `NODE_PATH` from `$MARU_SKILLS_ENV`, the active hashed env, or the legacy location.

The shell differs from Maru only in broken states, which need Maru-side repair
either way (Bootstrap, or the state-file recovery Maru's error names):

- a hash Maru rejects (reserved name, invalid characters, a symlinked
  directory), or a state file that is unreadable, a symlink, or malformed so the
  hash no longer parses: Maru refuses, the shell uses the legacy location;
- a hashed-layout bundle whose hashed directory is missing: Maru returns that
  missing root, the shell uses the legacy location;
- a crashed rebuild that left a partial `<hash>` beside `<hash>.prev`: Maru
  restores `.prev`, the shell uses the partial root (the system interpreter
  with the repair hint when it has no python yet).

Ambient `$VIRTUAL_ENV` is intentionally ignored as an input so unrelated shell
venvs cannot shadow the Maru runtime. The Maru host injects `MARU_SKILLS_ENV`,
`VIRTUAL_ENV`, `PATH` (`+.venv/bin`), and `NODE_PATH` (`+node_modules`) for
in-app runs; the shell wrappers export `VIRTUAL_ENV`, `PATH` and `NODE_PATH`
so bare CLI sessions match.

## Session hook

`.claude/hooks/init-env.sh` resolves the env from `$MARU_SKILLS_ENV`, then the
active hashed env (or, without one, the legacy `~/.maru/env`), then a walk-up
from the project directory that, like the wrappers', stops at `~/.maru`; when
the active env has no `.venv/bin/python3` it prints the repair step before the
walk-up, and with nothing found it writes nothing. When
`CLAUDE_ENV_FILE` is set, writes `MARU_SKILLS_ENV`, `VIRTUAL_ENV`, `PATH` and
(when `node_modules` exists) `NODE_PATH` into it, so later tool calls in the
session use the shared runtime. Register it once as a SessionStart hook in the
host's user settings, so every project gets it: from an installed bundle the
command is `~/.maru/skills/_builtin/envs/default/.claude/hooks/init-env.sh`, and
in a checkout of this repo it is `envs/default/.claude/hooks/init-env.sh` under
the checkout.
