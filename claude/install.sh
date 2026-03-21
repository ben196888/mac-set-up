#!/bin/bash
set -e

BASEDIR=$(dirname "$0")
CLAUDE_DIR="$HOME/.claude"

# Parse flags
YES=false
for arg in "$@"; do
  case "$arg" in
    -y|--yes) YES=true ;;
  esac
done

# Helper: ask to overwrite, respects -y flag and non-interactive mode
should_overwrite() {
  local name="$1"
  local kind="$2"
  if [ "$YES" = true ]; then
    return 0
  fi
  printf "  %s '%s' already exists. Overwrite? [y/N] " "$kind" "$name"
  if ! read -r answer </dev/tty 2>/dev/null; then
    echo ""
    echo "  → Non-interactive: skipping existing $kind '$name'"
    return 1
  fi
  case "$answer" in
    [yY]*) return 0 ;;
    *)     return 1 ;;
  esac
}

echo "Setting up Claude Code configuration..."

# Install global CLAUDE.md (user-level instructions)
CLAUDE_MD_SRC="$BASEDIR/CLAUDE.md"
CLAUDE_MD_DEST="$CLAUDE_DIR/CLAUDE.md"
if [ ! -e "$CLAUDE_MD_DEST" ]; then
  cp "$CLAUDE_MD_SRC" "$CLAUDE_MD_DEST"
  echo "Copied global CLAUDE.md"
elif diff -q "$CLAUDE_MD_SRC" "$CLAUDE_MD_DEST" >/dev/null 2>&1; then
  echo "CLAUDE.md already up to date — skipping"
else
  echo "CLAUDE.md exists and differs from source — merging with Claude Code..."
  EXISTING=$(cat "$CLAUDE_MD_DEST")
  INCOMING=$(cat "$CLAUDE_MD_SRC")
  MERGED=$(claude -p --no-input "You are merging two CLAUDE.md files into one. Preserve all unique instructions from both. Remove exact duplicates. Keep the result well-organized with clear markdown headings. Output ONLY the merged file content, no explanation.

--- EXISTING ~/.claude/CLAUDE.md ---
$EXISTING

--- INCOMING claude/CLAUDE.md ---
$INCOMING" 2>/dev/null) || true
  if [ -n "$MERGED" ]; then
    echo "$MERGED" > "$CLAUDE_MD_DEST"
    echo "  → Merged CLAUDE.md with Claude Code"
  else
    echo "  → Claude Code merge failed — falling back to prompt"
    if should_overwrite "CLAUDE.md" "File"; then
      cp "$CLAUDE_MD_SRC" "$CLAUDE_MD_DEST"
      echo "  → Overwritten: CLAUDE.md"
    else
      echo "  → Skipped: CLAUDE.md"
    fi
  fi
fi

# Copy settings.json
if [ ! -e "$CLAUDE_DIR/settings.json" ]; then
  cp "$BASEDIR/settings.json" "$CLAUDE_DIR/settings.json"
  echo "Copied settings.json"
else
  echo "settings.json already exists at $CLAUDE_DIR/settings.json — skipping"
fi

# Copy commands (per-file: prompt on existing, append new)
mkdir -p "$CLAUDE_DIR/commands"
for src in "$BASEDIR/commands"/*.md; do
  name=$(basename "$src")
  dest="$CLAUDE_DIR/commands/$name"
  if [ -e "$dest" ]; then
    if should_overwrite "$name" "Command"; then
      cp "$src" "$dest"
      echo "  → Overwritten: $name"
    else
      echo "  → Skipped: $name"
    fi
  else
    cp "$src" "$dest"
    echo "  Added command: $name"
  fi
done

# Copy skills (per-skill: prompt on existing, append new)
mkdir -p "$CLAUDE_DIR/skills"
for src in "$BASEDIR/skills"/*/; do
  name=$(basename "$src")
  dest="$CLAUDE_DIR/skills/$name"
  if [ -e "$dest" ]; then
    if should_overwrite "$name" "Skill"; then
      cp -r "$src" "$dest"
      echo "  → Overwritten: $name"
    else
      echo "  → Skipped: $name"
    fi
  else
    cp -r "$src" "$dest"
    echo "  Added skill: $name"
  fi
done

# Register MCP servers via claude CLI (writes to ~/.claude.json at user scope)
if claude mcp get discord >/dev/null 2>&1; then
  echo "Discord MCP already registered — skipping"
else
  claude mcp add --scope user discord -- npx -y discord-mcp@latest
  echo "Registered Discord MCP server"
fi

echo "Claude Code configuration complete."
echo "NOTE: Discord MCP requires DISCORD_TOKEN to be set in your environment."
