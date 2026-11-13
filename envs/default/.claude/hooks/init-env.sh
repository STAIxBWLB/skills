#!/usr/bin/env bash
# init-env.sh — Maru 공유 런타임 활성화
# Claude Code SessionStart 훅에서 CLAUDE_ENV_FILE 로 환경변수를 주입한다.
# Rust 호스트(env_vars_for_runs)와 동일한 변수 세트를 내보낸다:
#   MARU_SKILLS_ENV, VIRTUAL_ENV, PATH(+.venv/bin), NODE_PATH(+node_modules)

set -euo pipefail

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

ACTIVE="$(maru_active_env || true)"

resolve_env_root() {
    # 1. 명시적 호스트 주입 변수
    if [[ -n "${MARU_SKILLS_ENV:-}" && -x "$MARU_SKILLS_ENV/.venv/bin/python3" ]]; then
        printf '%s\n' "$MARU_SKILLS_ENV"; return 0
    fi
    # 2. Maru가 기록한 활성 해시 env가 있으면 그것, 없을 때만 legacy 고정 위치.
    # Ambient VIRTUAL_ENV is intentionally ignored so an unrelated shell venv
    # cannot shadow the Maru runtime.
    if [[ -n "$ACTIVE" ]]; then
        [[ -x "$ACTIVE/.venv/bin/python3" ]] && printf '%s\n' "$ACTIVE" && return 0
        echo "[init-env] 활성 Maru env에 python 없음: $ACTIVE (빌드 미완료 또는 삭제). legacy ~/.maru/env는 쓰지 않고 작업 트리 env를 찾음. 복구: Maru 설정 > Skills > Bootstrap" >&2
    elif [[ -x "$HOME/.maru/env/.venv/bin/python3" ]]; then
        printf '%s\n' "$HOME/.maru/env"; return 0
    fi
    # 3. 프로젝트 디렉토리에서 상위로 탐색 (dev-in-tree)
    local dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
    while [[ "$dir" != "/" ]]; do
        [[ "$dir" -ef "$HOME/.maru" ]] && break  # ~/.maru/env is the legacy env: never via the walk-up
        for candidate in \
            "$dir/env" \
            "$dir/envs/default" \
            "$dir/skills/envs/default"; do
            [[ -x "$candidate/.venv/bin/python3" ]] && printf '%s\n' "$candidate" && return 0
        done
        dir="$(dirname "$dir")"
    done
    return 1
}

ENV_ROOT="$(resolve_env_root)" || {
    [[ -n "$ACTIVE" ]] && exit 0  # resolve_env_root already printed the repair hint
    echo "[init-env] Maru env 미발견 (MARU_SKILLS_ENV, 활성 해시 env, ~/.maru/env, 작업 트리 모두 .venv/bin/python3 없음). 스킵. 복구: Maru 설정 > Skills > Bootstrap (Maru 앱 없이: 번들 또는 checkout의 envs/default/setup.sh --target ~/.maru/env)" >&2
    exit 0
}

VENV_BIN="$ENV_ROOT/.venv/bin"  # resolve_env_root only returns roots with an executable python3

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
