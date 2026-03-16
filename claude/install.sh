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

# Copy commands directory
if [ ! -e "$CLAUDE_DIR/commands" ]; then
  cp -r "$BASEDIR/commands" "$CLAUDE_DIR/commands"
  echo "Copied commands/"
else
  echo "commands/ already exists at $CLAUDE_DIR/commands — skipping"
fi

# Copy skills directory
if [ ! -e "$CLAUDE_DIR/skills" ]; then
  cp -r "$BASEDIR/skills" "$CLAUDE_DIR/skills"
  echo "Copied skills/"
else
  echo "skills/ already exists at $CLAUDE_DIR/skills — skipping"
fi

echo "Claude Code configuration complete."
