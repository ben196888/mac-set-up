#!/bin/bash
set -euo pipefail

BASEDIR=$(dirname "$0")
CODEX_DIR="$HOME/.codex"
source "$BASEDIR/../agentic_skills.sh"

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
    echo "  -> Non-interactive: skipping existing $kind '$name'"
    return 1
  fi
  case "$answer" in
    [yY]*) return 0 ;;
    *)     return 1 ;;
  esac
}

install_agentic_skills() {
  if ! command -v npx >/dev/null 2>&1; then
    echo "npx not found - skipping skill installation"
    return 0
  fi

  local skill_name
  local skill_package
  local skill
  for skill in "${AGENTIC_SKILLS[@]}"; do
    IFS='|' read -r skill_name skill_package <<< "$skill"
    npx skills add "$skill_package" --skill '*' --agent codex --copy -g -y
    echo "Installed $skill_name skills for Codex"
  done
}

echo "Setting up Codex configuration..."

mkdir -p "$CODEX_DIR"

# Install global AGENTS.md (user-level instructions)
AGENTS_MD_SRC="$BASEDIR/AGENTS.md"
AGENTS_MD_DEST="$CODEX_DIR/AGENTS.md"
if [ ! -e "$AGENTS_MD_DEST" ]; then
  cp "$AGENTS_MD_SRC" "$AGENTS_MD_DEST"
  echo "Copied global AGENTS.md"
elif diff -q "$AGENTS_MD_SRC" "$AGENTS_MD_DEST" >/dev/null 2>&1; then
  echo "AGENTS.md already up to date — skipping"
else
  echo "AGENTS.md exists and differs from source — merging with Codex..."
  EXISTING=$(cat "$AGENTS_MD_DEST")
  INCOMING=$(cat "$AGENTS_MD_SRC")
  MERGED=$(codex exec -q "You are merging two AGENTS.md files into one. Preserve all unique instructions from both. Remove exact duplicates. Keep the result well-organized with clear markdown headings. Output ONLY the merged file content, no explanation.

--- EXISTING ~/.codex/AGENTS.md ---
$EXISTING

--- INCOMING codex/AGENTS.md ---
$INCOMING" 2>/dev/null) || true
  if [ -n "$MERGED" ]; then
    echo "$MERGED" > "$AGENTS_MD_DEST"
    echo "  -> Merged AGENTS.md with Codex"
  else
    echo "  -> Codex merge failed — falling back to prompt"
    if should_overwrite "AGENTS.md" "File"; then
      cp "$AGENTS_MD_SRC" "$AGENTS_MD_DEST"
      echo "  -> Overwritten: AGENTS.md"
    else
      echo "  -> Skipped: AGENTS.md"
    fi
  fi
fi

# Install shared agentic skills from their source-of-truth repository.
install_agentic_skills

# Register MCP servers via codex CLI when available
if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI not found - skipping MCP registration"
elif codex mcp get discord >/dev/null 2>&1; then
  echo "Discord MCP already registered - skipping"
else
  codex mcp add discord -- npx -y discord-mcp@latest
  echo "Registered Discord MCP server"
fi

echo "Codex configuration complete."
echo "NOTE: Discord MCP requires DISCORD_TOKEN to be set in your environment."
