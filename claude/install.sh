#!/bin/bash
set -e

BASEDIR=$(dirname "$0")
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code configuration..."

# Copy settings.json
if [ ! -e "$CLAUDE_DIR/settings.json" ]; then
  cp "$BASEDIR/settings.json" "$CLAUDE_DIR/settings.json"
  echo "Copied settings.json"
else
  echo "settings.json already exists at $CLAUDE_DIR/settings.json — skipping"
fi

# Copy commands (per-file: overwrite existing, append new)
mkdir -p "$CLAUDE_DIR/commands"
for src in "$BASEDIR/commands"/*.md; do
  name=$(basename "$src")
  dest="$CLAUDE_DIR/commands/$name"
  if [ -e "$dest" ]; then
    cp "$src" "$dest"
    echo "Updated command: $name"
  else
    cp "$src" "$dest"
    echo "Added command: $name"
  fi
done

# Copy skills (per-skill: overwrite existing, append new)
mkdir -p "$CLAUDE_DIR/skills"
for src in "$BASEDIR/skills"/*/; do
  name=$(basename "$src")
  dest="$CLAUDE_DIR/skills/$name"
  if [ -e "$dest" ]; then
    cp -r "$src" "$dest"
    echo "Updated skill: $name"
  else
    cp -r "$src" "$dest"
    echo "Added skill: $name"
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
