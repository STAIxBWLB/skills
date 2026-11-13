#!/usr/bin/env bash
# init-env.sh — Maru 공유 런타임 활성화
# Claude Code SessionStart 훅에서 CLAUDE_ENV_FILE 로 환경변수를 주입한다.
# Rust 호스트(env_vars_for_runs)와 동일한 변수 세트를 내보낸다:
#   MARU_SKILLS_ENV, VIRTUAL_ENV, PATH(+.venv/bin), NODE_PATH(+node_modules)

set -euo pipefail

# Maru's active hashed env: ~/.maru/env/<active.envHash> from bundle-state.json,
# once its build completed. Prints nothing when there is none.
maru_active_env() {
    local h
    h="$(tr -d '\n' < "$HOME/.maru/skills/bundle-state.json" 2>/dev/null \
        | sed -n 's/.*"active"[[:space:]]*:[[:space:]]*{[^}]*"envHash"[[:space:]]*:[[:space:]]*"\([a-z0-9_-]*\)".*/\1/p')"
    [ -n "$h" ] && [ -f "$HOME/.maru/env/$h/.maru-env-complete" ] && printf '%s\n' "$HOME/.maru/env/$h"
}

resolve_env_root() {
    local active
    # 1. 명시적 호스트 주입 변수
    if [[ -n "${MARU_SKILLS_ENV:-}" && -d "$MARU_SKILLS_ENV/.venv" ]]; then
        printf '%s\n' "$MARU_SKILLS_ENV"; return 0
    fi
    # 2. Maru가 기록한 활성 해시 env (bundle-state.json active.envHash, 빌드 완료분)
    active="$(maru_active_env || true)"
    if [[ -n "$active" && -d "$active/.venv" ]]; then
        printf '%s\n' "$active"; return 0
    fi
    # 3. legacy 고정 위치. Ambient VIRTUAL_ENV is intentionally ignored so an
    # unrelated shell venv cannot shadow the Maru runtime.
    if [[ -d "$HOME/.maru/env/.venv" ]]; then
        printf '%s\n' "$HOME/.maru/env"; return 0
    fi
    # 4. 프로젝트 디렉토리에서 상위로 탐색 (dev-in-tree)
    local dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
    while [[ "$dir" != "/" ]]; do
        for candidate in \
            "$dir/env" \
            "$dir/envs/default" \
            "$dir/skills/envs/default"; do
            [[ -d "$candidate/.venv" ]] && printf '%s\n' "$candidate" && return 0
        done
        dir="$(dirname "$dir")"
    done
    return 1
}

ENV_ROOT="$(resolve_env_root)" || {
    echo "[init-env] Maru env 미발견 (MARU_SKILLS_ENV, 활성 해시 env, ~/.maru/env, 작업 트리 모두 .venv 없음). 스킵. 복구: maru skills update --apply --repair-env (Maru 없이: bash ~/.maru/skills/_builtin/envs/default/setup.sh --target ~/.maru/env)" >&2
    exit 0
}

VENV_BIN="$ENV_ROOT/.venv/bin"
if [[ ! -x "$VENV_BIN/python3" ]]; then
    echo "[init-env] venv 미설치: $ENV_ROOT" >&2
    exit 0
fi

if [[ -n "${CLAUDE_ENV_FILE:-}" ]]; then
    {
        echo "export MARU_SKILLS_ENV=\"$ENV_ROOT\""
        echo "export VIRTUAL_ENV=\"$ENV_ROOT/.venv\""
        echo "export PATH=\"$VENV_BIN:\$PATH\""
        if [[ -d "$ENV_ROOT/node_modules" ]]; then
            echo "export NODE_PATH=\"$ENV_ROOT/node_modules\${NODE_PATH:+:\$NODE_PATH}\""
        fi
    } >> "$CLAUDE_ENV_FILE"
    echo "[init-env] 활성화: $ENV_ROOT (venv+node)" >&2
fi

exit 0
