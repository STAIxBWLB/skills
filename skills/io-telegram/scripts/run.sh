#!/usr/bin/env bash
# run.sh — Maru skills python interpreter wrapper (io-telegram)
#
# telethon 은 Maru env(.venv)에만 설치되므로 auth.py/telegram_monitor.py
# 는 반드시 이 wrapper 를 통해 실행한다.
#
# 우선순위:
#   1. $SKILL_PYTHON (caller override)
#   2. $MARU_SKILLS_ENV (host 주입) → Maru 활성 해시 env (없을 때만 ~/.maru/env/.venv legacy)
#   3. repo-local env/.venv (dev-in-tree)
#   4. python3 on PATH (경고 출력)
#
# venv 미설치 시: maru skills update --apply --repair-env

set -euo pipefail
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Resolve the Maru skills python interpreter, most-specific first.
# Honors $SKILL_PYTHON, then host-injected $MARU_SKILLS_ENV, then Maru's active
# hashed env (or, when there is none, the legacy ~/.maru/env), then a repo-local
# walk-up (dev-in-tree).
# Canonical snippet — keep in sync with envs/default/REFERENCE.md.
# Maru's active hashed env, as Maru's env_root() picks it: ~/.maru/env/<active.envHash>
# from bundle-state.json when that directory exists, built or not. Prints nothing
# (no state file, no active hash, a name Maru rejects, no directory) to fall through.
maru_active_env() {
  local f="$HOME/.maru/skills/bundle-state.json" h
  [ -f "$f" ] && [ -r "$f" ] && [ ! -L "$f" ] || return 1
  h="$(tr -d '\n' < "$f" \
      | sed -n 's/.*"active"[[:space:]]*:[[:space:]]*{[^}]*"envHash"[[:space:]]*:[[:space:]]*"\([a-z0-9_-]*\)".*/\1/p')"
  case "$h" in ''|node|node_modules|temp|logs|input|output) return 1 ;; esac
  [ -d "$HOME/.maru/env/$h" ] && [ ! -L "$HOME/.maru/env/$h" ] && printf '%s\n' "$HOME/.maru/env/$h"
}

find_env_python() {
  local c dir active
  active="$(maru_active_env || true)"
  if [[ -n "${SKILL_PYTHON:-}" && -x "${SKILL_PYTHON}" ]]; then
    printf '%s\n' "$SKILL_PYTHON"; return 0
  fi
  for c in \
    "${MARU_SKILLS_ENV:+$MARU_SKILLS_ENV/.venv/bin/python3}" \
    "${active:-$HOME/.maru/env}/.venv/bin/python3"; do
    [[ -n "$c" && -x "$c" ]] && printf '%s\n' "$c" && return 0
  done
  dir="$SKILL_DIR"
  while [[ "$dir" != "/" ]]; do
    [[ "$dir" -ef "$HOME/.maru" ]] && break  # ~/.maru/env is the legacy env: never via the walk-up
    for c in \
      "$dir/env/.venv/bin/python3" \
      "$dir/envs/default/.venv/bin/python3" \
      "$dir/skills/envs/default/.venv/bin/python3"; do
      [[ -x "$c" ]] && printf '%s\n' "$c" && return 0
    done
    dir="$(dirname "$dir")"
  done
  return 1
}

PYTHON="$(find_env_python || true)"
if [[ -z "$PYTHON" || ! -x "$PYTHON" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    PYTHON="$(command -v python3)"
    echo "WARN: Maru env python 미발견, system python3 fallback: $PYTHON (telethon 미설치 가능; 복구: maru skills update --apply --repair-env, Maru 없이: bash ~/.maru/skills/_builtin/envs/default/setup.sh --target ~/.maru/env)" >&2
  else
    echo "ERROR: no python: Maru env도 system python3도 찾지 못함. 'maru skills update --apply --repair-env' 실행 (Maru 없이: bash ~/.maru/skills/_builtin/envs/default/setup.sh --target ~/.maru/env)" >&2
    exit 1
  fi
fi

# Export the resolved runtime so venv/node-based steps work in a bare session too.
case "$PYTHON" in
  */.venv/bin/python3)
    _ENV_ROOT="$(cd "$(dirname "$PYTHON")/../.." && pwd -P)"
    export VIRTUAL_ENV="$_ENV_ROOT/.venv"
    case ":$PATH:" in *":$_ENV_ROOT/.venv/bin:"*) ;; *) PATH="$_ENV_ROOT/.venv/bin:$PATH";; esac
    export PATH
    if [[ -d "$_ENV_ROOT/node_modules" ]]; then
      case ":${NODE_PATH:-}:" in *":$_ENV_ROOT/node_modules:"*) ;; *) NODE_PATH="$_ENV_ROOT/node_modules${NODE_PATH:+:$NODE_PATH}"; export NODE_PATH;; esac
    fi
    ;;
esac
exec "$PYTHON" "$@"
