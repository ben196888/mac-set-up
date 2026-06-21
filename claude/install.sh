#!/bin/bash
set -euo pipefail

BASEDIR=$(dirname "$0")
CLAUDE_DIR="$HOME/.claude"
HOMUNCULUS_SKILLS_PACKAGE="ben196888/Homunculus"
CAVEMAN_SKILLS_PACKAGE="JuliusBrussee/caveman"
PONYTAIL_SKILLS_PACKAGE="DietrichGebert/ponytail"

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

install_agentic_skills() {
  if ! command -v npx >/dev/null 2>&1; then
    echo "npx not found — skipping skill installation"
    return 0
  fi

  npx skills add "$HOMUNCULUS_SKILLS_PACKAGE" --skill '*' --agent claude-code --copy -g -y
  echo "Installed Homunculus skills for Claude Code"
  npx skills add "$CAVEMAN_SKILLS_PACKAGE" --skill '*' --agent claude-code --copy -g -y
  echo "Installed Caveman skills for Claude Code"
  npx skills add "$PONYTAIL_SKILLS_PACKAGE" --skill '*' --agent claude-code --copy -g -y
  echo "Installed Ponytail skills for Claude Code"
}

echo "Setting up Claude Code configuration..."

mkdir -p "$CLAUDE_DIR"

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

# Install shared agentic skills from their source-of-truth repository.
install_agentic_skills

# Register MCP servers via claude CLI (writes to ~/.claude.json at user scope)
if ! command -v claude >/dev/null 2>&1; then
  echo "Claude CLI not found — skipping MCP registration"
elif claude mcp get discord >/dev/null 2>&1; then
  echo "Discord MCP already registered — skipping"
else
  claude mcp add --scope user discord -- npx -y discord-mcp@latest
  echo "Registered Discord MCP server"
fi

echo "Claude Code configuration complete."
echo "NOTE: Discord MCP requires DISCORD_TOKEN to be set in your environment."
