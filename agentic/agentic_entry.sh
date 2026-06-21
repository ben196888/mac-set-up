#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
YES=false
TARGET=""

usage() {
  cat <<'EOF'
Usage: ./agentic/agentic_entry.sh --claude|--codex|--all [-y|--yes]

Install global agent entry files.

Options:
  --claude  Install CLAUDE.md for Claude Code
  --codex   Install AGENTS.md for Codex
  --all     Install entry files for Claude Code and Codex
  -y, --yes Overwrite on merge fallback without prompting
  -h, --help
           Show this help
EOF
}

should_overwrite() {
  local name="$1"
  local kind="$2"
  if [ "$YES" = true ]; then
    return 0
  fi

  printf "  %s '%s' already exists. Overwrite? [y/N] " "$kind" "$name"
  if ! read -r answer </dev/tty 2>/dev/null; then
    echo ""
    echo "  -> Non-interactive: skipping existing $kind '$name'"
    return 1
  fi

  case "$answer" in
    [yY]*) return 0 ;;
    *)     return 1 ;;
  esac
}

install_claude_entry() {
  local claude_dir="$HOME/.claude"
  mkdir -p "$claude_dir"
  install_entry "$SCRIPT_DIR/CLAUDE.md" "$claude_dir/CLAUDE.md" "Claude Code" "claude -p --no-input"
}

install_codex_entry() {
  local codex_dir="$HOME/.codex"
  mkdir -p "$codex_dir"
  install_entry "$SCRIPT_DIR/AGENTS.md" "$codex_dir/AGENTS.md" "Codex" "codex exec -q"
}

install_entry() {
  local src="$1"
  local dest="$2"
  local display="$3"
  local merge_cmd="$4"
  local name
  name="$(basename "$dest")"

  if [ ! -e "$dest" ]; then
    cp "$src" "$dest"
    echo "Copied global $name"
  elif diff -q "$src" "$dest" >/dev/null 2>&1; then
    echo "$name already up to date - skipping"
  else
    echo "$name exists and differs from source - merging with $display..."
    local existing
    local incoming
    local merged
    local prompt
    local -a merge_args
    existing=$(cat "$dest")
    incoming=$(cat "$src")
    prompt="You are merging two $name files into one. Preserve all unique instructions from both. Remove exact duplicates. Keep the result well-organized with clear markdown headings. Output ONLY the merged file content, no explanation.

--- EXISTING $dest ---
$existing

--- INCOMING $src ---
$incoming"
    read -r -a merge_args <<< "$merge_cmd"
    merged=$("${merge_args[@]}" "$prompt" 2>/dev/null) || true
    if [ -n "$merged" ]; then
      printf '%s\n' "$merged" > "$dest"
      echo "  -> Merged $name with $display"
    else
      echo "  -> $display merge failed - falling back to prompt"
      if should_overwrite "$name" "File"; then
        cp "$src" "$dest"
        echo "  -> Overwritten: $name"
      else
        echo "  -> Skipped: $name"
      fi
    fi
  fi
}

case "${1:-}" in
  --claude|--codex|--all)
    TARGET="$1"
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

if [ "$#" -gt 2 ]; then
  usage >&2
  exit 1
fi

case "${2:-}" in
  "")
    ;;
  -y|--yes)
    YES=true
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

case "$TARGET" in
  --claude)
    install_claude_entry
    ;;
  --codex)
    install_codex_entry
    ;;
  --all)
    install_claude_entry
    install_codex_entry
    ;;
esac
