#!/usr/bin/env bash
# Self-check for the env resolution order (envs/default/REFERENCE.md):
# runs the real skill wrappers and the SessionStart hook against a fake home
# and asserts which interpreter each one picks. Prints "ok" on success.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
WRAPPERS=(skills/pptx-toolkit/pptx skills/xlsx-toolkit/xlsx skills/io-telegram/scripts/run.sh skills/md2docx/md2docx)
HOOK=envs/default/.claude/hooks/init-env.sh

# Every copy of maru_active_env is the same function (indentation aside).
first=""
for w in "${WRAPPERS[@]}" "$HOOK"; do
    body="$(sed -n '/^maru_active_env() {/,/^}/p' "$REPO/$w" | sed 's/^[[:space:]]*//')"
    [[ -n "$body" ]] || { echo "FAIL: no maru_active_env in $w" >&2; exit 1; }
    [[ -z "$first" || "$body" == "$first" ]] || { echo "FAIL: maru_active_env in $w differs from ${WRAPPERS[0]}" >&2; exit 1; }
    first="$body"
done

T="$(mktemp -d)" || exit 1
T="$(cd "$T" && pwd -P)"  # physical: wrappers resolve env roots with pwd -P
[[ -d "$T" && "$T" != "$PWD" ]] || { echo "FAIL: no temp dir" >&2; exit 1; }
trap 'rm -rf "$T"' EXIT

fake() {  # fake interpreter: prints the path it ran as and the NODE_PATH it got
    mkdir -p "$(dirname "$1")"
    printf '#!/bin/sh\necho "RAN:$0"\necho "NODE_PATH:${NODE_PATH:-}"\n' > "$1"
    chmod +x "$1"
}

# The wrappers run from copies under $T; their dev-in-tree walk-up starts there.
for w in "${WRAPPERS[@]}" "$HOOK"; do
    mkdir -p "$T/w/$(dirname "$w")"
    cp "$REPO/$w" "$T/w/$w"
done
fake "$T/bin/python3"
fake "$T/bin/node"

A=aaa111 P=bbb222
E="$T/home/.maru/env"
reset_home() {
    rm -rf "${T:?}/home"
    mkdir -p "$T/home/.maru/skills"
    for h in "$A" "$P"; do
        fake "$E/$h/.venv/bin/python3"
        fake "$E/$h/node/bin/node"
        mkdir -p "$E/$h/node_modules"
        touch "$E/$h/.maru-env-complete"
    done
    fake "$E/.venv/bin/python3"
    fake "$E/node/bin/node"
    mkdir -p "$E/node_modules"
}
state() {  # state <active hash or "-"> : pretty JSON shaped like Maru's bundle-state.json
    local active=""
    [[ "$1" == "-" ]] || active="$(printf '  "active": {\n    "bundleId": "r2",\n    "revision": 2,\n    "source": "remote",\n    "envHash": "%s",\n    "appliedAt": "x"\n  },\n' "$1")"
    printf '{\n  "schema": 1,\n%s  "previous": {\n    "bundleId": "r1",\n    "envHash": "%s",\n    "appliedAt": "x"\n  }\n}\n' "$active" "$P" > "$T/home/.maru/skills/bundle-state.json"
}

EXTRA=()
out() {  # out <wrapper> <args...>: stdout and stderr of a wrapper copy
    env -i HOME="$T/home" PATH="$T/bin:/usr/bin:/bin" ${EXTRA[@]+"${EXTRA[@]}"} "$T/w/$1" "${@:2}" 2>&1
}
expect() {  # expect <label> <wanted interpreter> <output>
    local got; got="$(printf '%s\n' "$3" | sed -n 's/^RAN://p' | head -n1)"
    [[ "$got" == "$2" ]] || { echo "FAIL $1: wanted $2, got '${got:-nothing}'" >&2; printf '%s\n' "$3" >&2; exit 1; }
}
check_all() {  # check_all <label> <python> <node>
    expect "$1 pptx" "$2" "$(out skills/pptx-toolkit/pptx read x.pptx)"
    expect "$1 xlsx" "$2" "$(out skills/xlsx-toolkit/xlsx read x.xlsx)"
    expect "$1 run.sh" "$2" "$(out skills/io-telegram/scripts/run.sh x.py)"
    expect "$1 md2docx" "$3" "$(out skills/md2docx/md2docx x.md)"
}
hook() {  # hook <label> <wanted VIRTUAL_ENV or ""> [stderr substring]
    local f="$T/envfile" err got; : > "$f"
    err="$(env -i HOME="$T/home" PATH="$T/bin:/usr/bin:/bin" CLAUDE_ENV_FILE="$f" CLAUDE_PROJECT_DIR="$T/w" \
        ${EXTRA[@]+"${EXTRA[@]}"} bash "$T/w/$HOOK" 2>&1 >/dev/null)"
    got="$(sed -n 's/^export VIRTUAL_ENV="\(.*\)"$/\1/p' "$f")"
    [[ "$got" == "$2" ]] || { echo "FAIL hook $1: wanted '$2', got '$got' ($err)" >&2; exit 1; }
    [[ -z "${3:-}" || "$err" == *"$3"* ]] || { echo "FAIL hook $1: stderr lacks '$3': $err" >&2; exit 1; }
}

# 1. Maru-shaped state: the active hash wins over previous and legacy; NODE_PATH follows it
reset_home; state "$A"
check_all pretty "$E/$A/.venv/bin/python3" "$E/$A/node/bin/node"
[[ "$(out skills/md2docx/md2docx x.md)" == *"NODE_PATH:$E/$A/node_modules"* ]] || { echo "FAIL pretty md2docx NODE_PATH" >&2; exit 1; }
hook pretty "$E/$A/.venv"

# 2. compact state on one line: still the active hash, not previous
reset_home
printf '{"schema":1,"active":{"bundleId":"r2","envHash":"%s"},"previous":{"bundleId":"r1","envHash":"%s"}}' "$A" "$P" > "$T/home/.maru/skills/bundle-state.json"
check_all compact "$E/$A/.venv/bin/python3" "$E/$A/node/bin/node"

# 3. no active entry: legacy, never previous
reset_home; state -
check_all no-active "$E/.venv/bin/python3" "$E/node/bin/node"
[[ "$(out skills/md2docx/md2docx x.md)" == *"NODE_PATH:$E/node_modules"* ]] || { echo "FAIL no-active md2docx NODE_PATH" >&2; exit 1; }
hook no-active "$E/.venv"

# 4. active build not finished (no marker): still the active env, as Maru's env_root() picks it
reset_home; state "$A"; rm "$E/$A/.maru-env-complete"
check_all unfinished "$E/$A/.venv/bin/python3" "$E/$A/node/bin/node"
hook unfinished "$E/$A/.venv"

# 5. active env without a venv: never the legacy one; system python with a repair hint
reset_home; state "$A"; rm -rf "${E:?}/$A/.venv"
o="$(out skills/pptx-toolkit/pptx read x.pptx)"; expect no-venv "$T/bin/python3" "$o"
[[ "$o" == *"repair-env"* ]] || { echo "FAIL no-venv: no repair hint: $o" >&2; exit 1; }
hook no-venv "" "repair-env"
# 5b. ... and with a walk-up env present: wrappers and hook take it, the hook still warns
fake "$T/w/envs/default/.venv/bin/python3"
check_all no-venv-walkup "$T/w/envs/default/.venv/bin/python3" "$E/$A/node/bin/node"
hook no-venv-walkup "$T/w/envs/default/.venv" "repair-env"
rm -rf "${T:?}/w/envs/default/.venv"

# 5d. installed layout (wrappers under ~/.maru/skills): the walk-up must not reach the legacy env
rm -rf "${E:?}/$A/node"
for w in "${WRAPPERS[@]}"; do
    mkdir -p "$T/home/.maru/skills/_workspaces/x/$(dirname "$w")"
    cp "$REPO/$w" "$T/home/.maru/skills/_workspaces/x/$w"
done
for w in "${WRAPPERS[@]}"; do
    o="$(env -i HOME="$T/home" PATH="$T/bin:/usr/bin:/bin" "$T/home/.maru/skills/_workspaces/x/$w" x 2>&1)"
    [[ "$o" != *"$E/.venv"* && "$o" != *"$E/node/"* ]] || { echo "FAIL installed $w: used the legacy env: $o" >&2; exit 1; }
done

# 5e. active .venv present but without python3: the hook treats it as unusable and takes the walk-up
reset_home; state "$A"; rm "$E/$A/.venv/bin/python3"
fake "$T/w/envs/default/.venv/bin/python3"
hook no-python "$T/w/envs/default/.venv" "repair-env"
rm -rf "${T:?}/w/envs/default/.venv"

# 5c. active env without bundled node: system node, NODE_PATH still from the active env
reset_home; state "$A"; rm -rf "${E:?}/$A/node"
o="$(out skills/md2docx/md2docx x.md)"; expect no-node "$T/bin/node" "$o"
[[ "$o" == *"NODE_PATH:$E/$A/node_modules"* ]] || { echo "FAIL no-node NODE_PATH: $o" >&2; exit 1; }

# 6. recorded hash without a directory (a pre-hash app): legacy
reset_home; state ccc333
check_all no-dir "$E/.venv/bin/python3" "$E/node/bin/node"

# 7. a hash Maru rejects (reserved name): legacy (Maru refuses; REFERENCE.md lists this)
reset_home; state node
check_all reserved "$E/.venv/bin/python3" "$E/node/bin/node"

# 7b. a symlinked hash directory, which Maru also rejects: legacy
reset_home; ln -s "$E/$A" "$E/lnk"; state lnk
check_all symlink "$E/.venv/bin/python3" "$E/node/bin/node"

# 8. host-injected MARU_SKILLS_ENV outranks the state file
reset_home; state "$A"; EXTRA=(MARU_SKILLS_ENV="$E/$P")
check_all injected "$E/$P/.venv/bin/python3" "$E/$P/node/bin/node"
hook injected "$E/$P/.venv"
EXTRA=()

# 9. nothing installed, no state file: system interpreter, and no stray shell errors
rm -rf "${T:?}/home"; mkdir -p "$T/home"
check_all none "$T/bin/python3" "$T/bin/node"
for w in "${WRAPPERS[@]}"; do
    o="$(out "$w" x)"
    [[ "$o" != *"No such file"* ]] || { echo "FAIL none $w: stray error: $o" >&2; exit 1; }
done

# 10. unreadable state file: legacy, and no stray shell errors
reset_home; state "$A"; chmod 000 "$T/home/.maru/skills/bundle-state.json"
if [[ ! -r "$T/home/.maru/skills/bundle-state.json" ]]; then  # root reads anyway; skip there
    check_all unreadable "$E/.venv/bin/python3" "$E/node/bin/node"
    o="$(out skills/pptx-toolkit/pptx read x.pptx)"
    [[ "$o" != *"Permission denied"* ]] || { echo "FAIL unreadable: stray error: $o" >&2; exit 1; }
fi
chmod 644 "$T/home/.maru/skills/bundle-state.json"

echo ok
