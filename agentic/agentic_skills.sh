#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/agentic.conf"

usage() {
  cat <<'EOF'
Usage: ./agentic/agentic_skills.sh --claude|--codex|--all

Install shared skill repositories for agentic tools.

Options:
  --claude  Install skills for Claude Code
  --codex   Install skills for Codex
  --all     Install skills for Claude Code and Codex
  -h, --help
           Show this help
EOF
}

install_agentic_skills() {
  local skills_agent="$1"
  local agent_name="$2"

  if ! command -v npx >/dev/null 2>&1; then
    echo "npx not found - skipping skill installation"
    return 0
  fi

  local skill_name
  local skill_package
  local skill
  for skill in "${AGENTIC_SKILLS[@]}"; do
    IFS='|' read -r skill_name skill_package <<< "$skill"
    npx skills add "$skill_package" --skill '*' --agent "$skills_agent" --copy -g -y
    echo "Installed $skill_name skills for $agent_name"
  done
}

if [ "$#" -gt 1 ]; then
  usage >&2
  exit 1
fi

case "${1:-}" in
  --claude)
    install_agentic_skills "claude-code" "Claude Code"
    ;;
  --codex)
    install_agentic_skills "codex" "Codex"
    ;;
  --all)
    install_agentic_skills "claude-code" "Claude Code"
    install_agentic_skills "codex" "Codex"
    ;;
  -h|--help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
