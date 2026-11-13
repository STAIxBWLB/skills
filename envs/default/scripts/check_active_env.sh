#!/usr/bin/env bash
# Self-check for the env resolution order (envs/default/REFERENCE.md):
# runs the real skill wrappers and the SessionStart hook against a fake home
# and asserts which interpreter each one picks. Prints "ok" on success.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT

fake() {  # fake interpreter: prints the path it was run as
    mkdir -p "$(dirname "$1")"
    printf '#!/bin/sh\necho "RAN:$0"\n' > "$1"
    chmod +x "$1"
}

# Copies of the wrappers live under $T so the dev-in-tree walk-up stays inside it.
for w in skills/pptx-toolkit/pptx skills/xlsx-toolkit/xlsx skills/io-telegram/scripts/run.sh skills/md2docx/md2docx envs/default/.claude/hooks/init-env.sh; do
    mkdir -p "$T/w/$(dirname "$w")"
    cp "$REPO/$w" "$T/w/$w"
done
fake "$T/bin/python3"
fake "$T/bin/node"

A=aaa111 P=bbb222
reset_home() {
    rm -rf "${T:?}/home"
    mkdir -p "$T/home/.maru/skills"
    for h in "$A" "$P"; do
        fake "$T/home/.maru/env/$h/.venv/bin/python3"
        fake "$T/home/.maru/env/$h/node/bin/node"
        touch "$T/home/.maru/env/$h/.maru-env-complete"
    done
    fake "$T/home/.maru/env/.venv/bin/python3"
    fake "$T/home/.maru/env/node/bin/node"
}
pretty() {
    printf '{\n  "schema": 1,\n  "active": {\n    "bundleId": "r2",\n    "envHash": "%s",\n    "appliedAt": "x"\n  },\n  "previous": {\n    "bundleId": "r1",\n    "envHash": "%s",\n    "appliedAt": "x"\n  }\n}\n' "$A" "$P" > "$T/home/.maru/skills/bundle-state.json"
}

run() {  # run <wrapper> <args...>: prints the RAN: line
    env -i HOME="$T/home" PATH="$T/bin:/usr/bin:/bin" "$T/w/$1" "${@:2}" 2>/dev/null | grep '^RAN:' | head -n1
}
expect() {  # expect <label> <wanted path> <actual RAN line>
    [[ "$3" == "RAN:$2" ]] || { echo "FAIL $1: wanted $2, got '${3:-nothing}'" >&2; exit 1; }
}
check_all() {  # check_all <label> <python path> <node path>
    expect "$1 pptx" "$2" "$(run skills/pptx-toolkit/pptx read x.pptx)"
    expect "$1 xlsx" "$2" "$(run skills/xlsx-toolkit/xlsx read x.xlsx)"
    expect "$1 run.sh" "$2" "$(run skills/io-telegram/scripts/run.sh x.py)"
    expect "$1 md2docx" "$3" "$(run skills/md2docx/md2docx x.md)"
}
hook_root() {  # prints the VIRTUAL_ENV the hook writes
    local f="$T/envfile"; : > "$f"
    env -i HOME="$T/home" PATH="$T/bin:/usr/bin:/bin" CLAUDE_ENV_FILE="$f" CLAUDE_PROJECT_DIR="$T/w" \
        bash "$T/w/envs/default/.claude/hooks/init-env.sh" 2>/dev/null
    sed -n 's/^export VIRTUAL_ENV="\(.*\)"$/\1/p' "$f"
}
E="$T/home/.maru/env"

# 1. pretty state: the active hash wins over previous and legacy
reset_home; pretty
check_all pretty "$E/$A/.venv/bin/python3" "$E/$A/node/bin/node"
[[ "$(hook_root)" == "$E/$A/.venv" ]] || { echo "FAIL hook pretty: $(hook_root)" >&2; exit 1; }

# 2. compact state on one line: still the active hash, not previous
reset_home
printf '{"schema":1,"active":{"bundleId":"r2","envHash":"%s"},"previous":{"bundleId":"r1","envHash":"%s"}}' "$A" "$P" > "$T/home/.maru/skills/bundle-state.json"
check_all compact "$E/$A/.venv/bin/python3" "$E/$A/node/bin/node"

# 3. no active entry: legacy, never previous
reset_home
printf '{"schema":1,"previous":{"bundleId":"r1","envHash":"%s"}}' "$P" > "$T/home/.maru/skills/bundle-state.json"
check_all no-active "$E/.venv/bin/python3" "$E/node/bin/node"
[[ "$(hook_root)" == "$E/.venv" ]] || { echo "FAIL hook no-active: $(hook_root)" >&2; exit 1; }

# 4. active build not complete: legacy
reset_home; pretty; rm "$E/$A/.maru-env-complete"
check_all incomplete "$E/.venv/bin/python3" "$E/node/bin/node"

# 5. host-injected MARU_SKILLS_ENV outranks the state file
reset_home; pretty
got="$(env -i HOME="$T/home" PATH="$T/bin:/usr/bin:/bin" MARU_SKILLS_ENV="$E/$P" "$T/w/skills/pptx-toolkit/pptx" read x.pptx 2>/dev/null | grep '^RAN:')"
expect injected "$E/$P/.venv/bin/python3" "$got"

# 6. nothing installed: system interpreter fallback
rm -rf "${T:?}/home"; mkdir -p "$T/home"
check_all none "$T/bin/python3" "$T/bin/node"

echo ok
