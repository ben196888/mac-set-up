# Plan: Discord MCP

## Goal

Configure Discord MCP server for agentic tools.

## Approach

- `agentic/agentic_mcp.sh` registers Discord MCP for Claude Code and Codex
- `agentic/agentic.conf` defines the Discord MCP command
- Claude Code config is written to `~/.claude.json` at user scope
- Codex config is managed through `codex mcp add`
- Idempotent: checks the target agent's `mcp get discord` before registering
- Token is NOT hardcoded — must be set as an environment variable before use

## Install command

```bash
claude mcp add --scope user discord -- npx -y discord-mcp@latest
codex mcp add discord -- npx -y discord-mcp@latest
```

## Environment variable (required)

Add to shell profile or set before running Claude Code:

```bash
export DISCORD_TOKEN=your_token
```

## Out of scope

- Other MCP servers (separate plan per server)
- Token management / secret storage
