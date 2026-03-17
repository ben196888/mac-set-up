# Plan: Discord MCP

## Goal

Configure Discord MCP server in Claude Code so Claude can interact with Discord.

## Approach

- `claude/install.sh` registers Discord MCP at user scope via `claude mcp add`
- Config is written to `~/.claude.json` (not `~/.claude/mcp.json` — that path is not read by Claude Code)
- Idempotent: checks `claude mcp get discord` before registering
- Token is NOT hardcoded — must be set as an environment variable before use

## Install command

```bash
claude mcp add --scope user discord -- npx -y discord-mcp@latest
```

## Environment variable (required)

Add to shell profile or set before running Claude Code:

```bash
export DISCORD_TOKEN=your_token
```

## Out of scope

- Other MCP servers (separate plan per server)
- Token management / secret storage
