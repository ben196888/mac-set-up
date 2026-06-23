#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/agentic.conf"

usage() {
  cat <<'EOF'
Usage: ./agentic/agentic_mcp.sh --claude|--codex|--all

Install shared MCP servers for agentic tools.

Options:
  --claude  Install MCP servers for Claude Code
  --codex   Install MCP servers for Codex
  --all     Install MCP servers for Claude Code and Codex
  -h, --help
           Show this help
EOF
}

install_mcps() {
  local cli="$1"
  local display="$2"
  local scope_name="${3:-}"
  local scope_value="${4:-}"

  if ! command -v "$cli" >/dev/null 2>&1; then
    echo "$display CLI not found - skipping MCP registration"
    return 0
  fi

  local mcp_name
  local mcp_command
  local mcp
  local -a command_args
  for mcp in "${AGENTIC_MCPS[@]}"; do
    IFS='|' read -r mcp_name mcp_command <<< "$mcp"
    if "$cli" mcp get "$mcp_name" >/dev/null 2>&1; then
      echo "$mcp_name MCP already registered for $display - skipping"
      continue
    fi

    read -r -a command_args <<< "$mcp_command"
    if [ -n "$scope_name" ]; then
      "$cli" mcp add "$scope_name" "$scope_value" "$mcp_name" -- "${command_args[@]}"
    else
      "$cli" mcp add "$mcp_name" -- "${command_args[@]}"
    fi
    echo "Registered $mcp_name MCP server for $display"
  done
}

install_claude_mcps() {
  install_mcps "claude" "Claude Code" "--scope" "user"
}

install_codex_mcps() {
  install_mcps "codex" "Codex"
}

if [ "$#" -ne 1 ]; then
  usage >&2
  exit 1
fi

case "$1" in
  --claude)
    install_claude_mcps
    ;;
  --codex)
    install_codex_mcps
    ;;
  --all)
    install_claude_mcps
    install_codex_mcps
    ;;
  -h|--help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
