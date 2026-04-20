#!/bin/bash
set -euo pipefail

BASEDIR=$(dirname "$0")
CODEX_DIR="$HOME/.codex"

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

safe_replace_dir() {
  local src="$1"
  local dest="$2"
  local parent="$3"

  case "$dest" in
    "$parent"/*) ;;
    *)
      echo "Refusing to replace unexpected path: $dest"
      return 1
      ;;
  esac

  rm -rf "$dest"
  cp -R "$src" "$dest"
}

echo "Setting up Codex configuration..."

mkdir -p "$CODEX_DIR"
mkdir -p "$CODEX_DIR/skills"

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

# Copy skills (per-skill: prompt on existing, append new)
for src in "$BASEDIR/../skills"/*/ "$BASEDIR/skills"/*/; do
  [ -d "$src" ] || continue
  name=$(basename "$src")
  dest="$CODEX_DIR/skills/$name"
  if [ -e "$dest" ]; then
    if should_overwrite "$name" "Skill"; then
      safe_replace_dir "$src" "$dest" "$CODEX_DIR/skills"
      echo "  -> Overwritten: $name"
    else
      echo "  -> Skipped: $name"
    fi
  else
    cp -r "$src" "$dest"
    echo "  Added skill: $name"
  fi
done

# Merge plugin entries from config.toml (append missing sections)
CODEX_CONFIG="$CODEX_DIR/config.toml"
while IFS= read -r line; do
  if [[ "$line" =~ ^\[plugins\. ]]; then
    plugin_id=$(echo "$line" | sed 's/\[plugins\."\(.*\)"\]/\1/')
    if grep -qF "[plugins.\"${plugin_id}\"]" "$CODEX_CONFIG" 2>/dev/null; then
      echo "Plugin ${plugin_id} already configured — skipping"
    else
      printf '\n%s\nenabled = true\n' "$line" >> "$CODEX_CONFIG"
      echo "  Added plugin: ${plugin_id}"
    fi
  fi
done < "$BASEDIR/config.toml"

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
