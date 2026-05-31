"""Path resolution for the hwpx skill's bundled-JRE runtime.

Layout (relative to this file):
  scripts/runtime_paths.py        ← __file__
  scripts/                        ← parent
  /                               ← SKILL_ROOT (skills/hwpx/)
  ~/.anchor/env/                  ← ENV_ROOT (.venv + node + jre host)
  runtime/                        ← bundled Java assets (in skill, committed)
"""
from __future__ import annotations

import os
from pathlib import Path

SKILL_ROOT = Path(__file__).resolve().parent.parent          # skills/hwpx/
RUNTIME = SKILL_ROOT / "runtime"


def _env_root() -> Path:
    """Resolve the Anchor skills env root (the .venv host), most-specific first.

    Mirrors the shell wrappers' find_env_python chain so the Python and shell
    layers agree on the same env regardless of how the skill is launched.
    """
    v = os.environ.get("ANCHOR_SKILLS_ENV")
    if v:
        p = Path(v).expanduser()
        if (p / ".venv").exists() or (p / "jre").exists():
            return p
    home_env = Path.home() / ".anchor" / "env"
    if (home_env / ".venv").exists():
        return home_env
    for base in (SKILL_ROOT, *SKILL_ROOT.parents):
        for candidate in (
            base / "env",
            base / "envs" / "default",
            base / "skills" / "envs" / "default",
        ):
            if (candidate / ".venv").exists() or (candidate / "pyproject.toml").exists():
                return candidate
    return home_env


def _jre_root() -> Path:
    """Resolve the bundled Java runtime.

    The canonical setup target provisions the JRE under ~/.anchor/env/jre.
    Source-tree locations stay as dev fallbacks.
    """
    candidates = [
        ENV_ROOT / "jre",
        Path.home() / ".anchor" / "skills" / "_builtin" / "envs" / "default" / "jre",
    ]
    for base in (SKILL_ROOT, *SKILL_ROOT.parents):
        candidates.append(base / "envs" / "default" / "jre")
        candidates.append(base / "skills" / "envs" / "default" / "jre")
        candidates.append(base / "env" / "jre")
    for c in candidates:
        if (c / "bin" / "java").exists():
            return c
    return ENV_ROOT / "jre"


ENV_ROOT = _env_root()
JRE_ROOT = _jre_root()

JAVA_BIN = JRE_ROOT / "bin" / "java"
HWPXLIB_JAR = RUNTIME / "hwpxlib-1.0.5.jar"
WRITER_CLASS_DIR = RUNTIME                                    # contains HwpxWriter.class
WRITER_CLASS = RUNTIME / "HwpxWriter.class"
TEMPLATE_HELPER = RUNTIME / "hwpx_template_export.py"
TIDY_TEMPLATES = RUNTIME / "templates"

VENV_PY = ENV_ROOT / ".venv" / "bin" / "python3"

SETUP_HINT = (
    "JRE 미설치. 다음을 실행:\n"
    "  bash ~/.anchor/skills/env/setup.sh --target ~/.anchor/env"
)


def classpath() -> str:
    return f"{HWPXLIB_JAR}{os.pathsep}{WRITER_CLASS_DIR}"


def assert_jre() -> None:
    """Fail fast with a helpful message if the bundled JRE/jar/class are missing."""
    missing = [str(p) for p in (JAVA_BIN, HWPXLIB_JAR, WRITER_CLASS) if not p.exists()]
    if missing:
        raise RuntimeError(
            "bundled-JRE writer 자산 누락:\n  - "
            + "\n  - ".join(missing)
            + f"\n\n{SETUP_HINT}"
        )


def tidy_template(template_id: str) -> Path:
    """Resolve a tidy-style template file (report/gongmun/minutes/proposal/notice)."""
    safe = "".join(c for c in template_id if c.isalnum() or c in "_-").lower() or "report"
    return TIDY_TEMPLATES / f"{safe}.hwpx"
