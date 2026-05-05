#!/usr/bin/env bash
# install.sh — install public skills into ~/.claude/skills

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
SKILLS_DST="$HOME/.claude/skills"
DRY_RUN=false
FORCE=false

usage() {
  echo "Usage: $0 [options] [skill-name...]"
  echo ""
  echo "Options:"
  echo "  -n, --dry-run   Show actions without changing links"
  echo "  -f, --force     Replace existing symlinks"
  echo "  -h, --help      Show help"
}

log() { echo "[install] $*"; }
ok()  { echo "  ok $*"; }
skip(){ echo "  - $* (skip)"; }
warn(){ echo "  ! $*"; }
die() { echo "error: $*" >&2; exit 1; }

skill_dirs() {
  find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -print | sort
}

collect_all_targets() {
  local src_dir
  while IFS= read -r src_dir; do
    [[ -f "$src_dir/SKILL.md" ]] && TARGETS+=("$(basename "$src_dir")")
  done < <(skill_dirs)
}

resolve_skill_src() {
  local skill="$1"
  local candidate="$SKILLS_SRC/$skill"
  [[ -f "$candidate/SKILL.md" ]] && printf '%s\n' "$candidate" && return 0
  return 1
}

TARGETS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=true; shift ;;
    -f|--force) FORCE=true; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option: $1" ;;
    *) TARGETS+=("$1"); shift ;;
  esac
done

[[ -d "$SKILLS_SRC" ]] || die "skills directory not found: $SKILLS_SRC"
if [[ ${#TARGETS[@]} -eq 0 ]]; then
  collect_all_targets
fi

log "source: $SKILLS_SRC"
log "target: $SKILLS_DST"
$DRY_RUN && log "dry-run: no changes"
echo ""

$DRY_RUN || mkdir -p "$SKILLS_DST"

for skill in "${TARGETS[@]}"; do
  if ! src="$(resolve_skill_src "$skill")"; then
    warn "skill not found: $skill"
    continue
  fi

  install_name="$(basename "$src")"
  dst="$SKILLS_DST/$install_name"

  if [[ -L "$dst" ]]; then
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      skip "$install_name already linked"
    elif $FORCE; then
      $DRY_RUN || rm "$dst"
      $DRY_RUN || ln -s "$src" "$dst"
      ok "$install_name relinked"
    else
      warn "$install_name existing link points elsewhere: $current (-f to replace)"
    fi
  elif [[ -e "$dst" ]]; then
    warn "$install_name target exists and is not a symlink: $dst"
  else
    $DRY_RUN || ln -s "$src" "$dst"
    ok "$install_name linked"
  fi
done

echo ""
log "done"
