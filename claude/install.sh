#!/bin/bash
set -e

BASEDIR=$(dirname "$0")
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code configuration..."

# Symlink settings.json
if [ ! -e "$CLAUDE_DIR/settings.json" ]; then
  ln -sf "$(realpath "$BASEDIR/settings.json")" "$CLAUDE_DIR/settings.json"
  echo "Linked settings.json"
else
  echo "settings.json already exists at $CLAUDE_DIR/settings.json — skipping"
fi

# Symlink commands directory
if [ ! -e "$CLAUDE_DIR/commands" ]; then
  ln -sf "$(realpath "$BASEDIR/commands")" "$CLAUDE_DIR/commands"
  echo "Linked commands/"
else
  echo "commands/ already exists at $CLAUDE_DIR/commands — skipping"
fi

echo "Claude Code configuration complete."
