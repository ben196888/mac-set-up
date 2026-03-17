# Plan: Discord MCP

## Goal

Configure Discord MCP server in Claude Code so Claude can interact with Discord.

## Approach

- `claude/mcp.json` — MCP server config tracked in this repo
- `claude/install.sh` copies it to `~/.claude/mcp.json` (with `-f` to safely overwrite)
- Token is NOT hardcoded — must be set as an environment variable before use

## Config

```json
{
  "mcpServers": {
    "discord": {
      "command": "npx",
      "args": ["discord-mcp@latest"]
    }
  }
}
```

## Environment variable (required)

Add to shell profile or set before running Claude Code:

```bash
export DISCORD_TOKEN=your_token
```

## Out of scope

- Other MCP servers (separate plan per server)
- Token management / secret storage
