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
  local src="$SCRIPT_DIR/CLAUDE.md"
  local dest="$claude_dir/CLAUDE.md"

  mkdir -p "$claude_dir"

  if [ ! -e "$dest" ]; then
    cp "$src" "$dest"
    echo "Copied global CLAUDE.md"
  elif diff -q "$src" "$dest" >/dev/null 2>&1; then
    echo "CLAUDE.md already up to date - skipping"
  else
    echo "CLAUDE.md exists and differs from source - merging with Claude Code..."
    local existing
    local incoming
    local merged
    existing=$(cat "$dest")
    incoming=$(cat "$src")
    merged=$(claude -p --no-input "You are merging two CLAUDE.md files into one. Preserve all unique instructions from both. Remove exact duplicates. Keep the result well-organized with clear markdown headings. Output ONLY the merged file content, no explanation.

--- EXISTING ~/.claude/CLAUDE.md ---
$existing

--- INCOMING agentic/CLAUDE.md ---
$incoming" 2>/dev/null) || true
    if [ -n "$merged" ]; then
      echo "$merged" > "$dest"
      echo "  -> Merged CLAUDE.md with Claude Code"
    else
      echo "  -> Claude Code merge failed - falling back to prompt"
      if should_overwrite "CLAUDE.md" "File"; then
        cp "$src" "$dest"
        echo "  -> Overwritten: CLAUDE.md"
      else
        echo "  -> Skipped: CLAUDE.md"
      fi
    fi
  fi
}

install_codex_entry() {
  local codex_dir="$HOME/.codex"
  local src="$SCRIPT_DIR/AGENTS.md"
  local dest="$codex_dir/AGENTS.md"

  mkdir -p "$codex_dir"

  if [ ! -e "$dest" ]; then
    cp "$src" "$dest"
    echo "Copied global AGENTS.md"
  elif diff -q "$src" "$dest" >/dev/null 2>&1; then
    echo "AGENTS.md already up to date - skipping"
  else
    echo "AGENTS.md exists and differs from source - merging with Codex..."
    local existing
    local incoming
    local merged
    existing=$(cat "$dest")
    incoming=$(cat "$src")
    merged=$(codex exec -q "You are merging two AGENTS.md files into one. Preserve all unique instructions from both. Remove exact duplicates. Keep the result well-organized with clear markdown headings. Output ONLY the merged file content, no explanation.

--- EXISTING ~/.codex/AGENTS.md ---
$existing

--- INCOMING agentic/AGENTS.md ---
$incoming" 2>/dev/null) || true
    if [ -n "$merged" ]; then
      echo "$merged" > "$dest"
      echo "  -> Merged AGENTS.md with Codex"
    else
      echo "  -> Codex merge failed - falling back to prompt"
      if should_overwrite "AGENTS.md" "File"; then
        cp "$src" "$dest"
        echo "  -> Overwritten: AGENTS.md"
      else
        echo "  -> Skipped: AGENTS.md"
      fi
    fi
  fi
}

for arg in "$@"; do
  case "$arg" in
    --claude|--codex|--all)
      if [ -n "$TARGET" ]; then
        usage >&2
        exit 1
      fi
      TARGET="$arg"
      ;;
    -y|--yes)
      YES=true
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
done

if [ -z "$TARGET" ]; then
  usage >&2
  exit 1
fi

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
