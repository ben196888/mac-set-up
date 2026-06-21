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

mcp_command_args() {
  local requested_mcp="$1"
  local mcp_name
  local mcp_command
  local mcp

  for mcp in "${AGENTIC_MCPS[@]}"; do
    IFS='|' read -r mcp_name mcp_command <<< "$mcp"
    if [ "$mcp_name" = "$requested_mcp" ]; then
      read -r -a MCP_COMMAND <<< "$mcp_command"
      return 0
    fi
  done

  echo "Unknown MCP server: $requested_mcp" >&2
  return 1
}

install_claude_mcps() {
  if ! command -v claude >/dev/null 2>&1; then
    echo "Claude CLI not found - skipping MCP registration"
    return 0
  fi

  local mcp_name
  local mcp_command
  local mcp
  for mcp in "${AGENTIC_MCPS[@]}"; do
    IFS='|' read -r mcp_name mcp_command <<< "$mcp"
    if claude mcp get "$mcp_name" >/dev/null 2>&1; then
      echo "$mcp_name MCP already registered for Claude Code - skipping"
      continue
    fi

    mcp_command_args "$mcp_name"
    claude mcp add --scope user "$mcp_name" -- "${MCP_COMMAND[@]}"
    echo "Registered $mcp_name MCP server for Claude Code"
  done
}

install_codex_mcps() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "Codex CLI not found - skipping MCP registration"
    return 0
  fi

  local mcp_name
  local mcp_command
  local mcp
  for mcp in "${AGENTIC_MCPS[@]}"; do
    IFS='|' read -r mcp_name mcp_command <<< "$mcp"
    if codex mcp get "$mcp_name" >/dev/null 2>&1; then
      echo "$mcp_name MCP already registered for Codex - skipping"
      continue
    fi

    mcp_command_args "$mcp_name"
    codex mcp add "$mcp_name" -- "${MCP_COMMAND[@]}"
    echo "Registered $mcp_name MCP server for Codex"
  done
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
