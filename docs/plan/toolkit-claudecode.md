# Plan: Claude Code Personal Toolkit

## Goal

Manage personal Claude Code configuration in this repo so it's reproducible across machines alongside the rest of the dev environment setup.

## Structure

```
claude/
├── install.sh          # Copies everything into ~/.claude/; registers MCPs
├── settings.json       # Global Claude Code preferences
├── commands/           # Custom slash commands (one .md per command)
│   ├── commit.md
│   ├── review-pr.md
│   └── simplify.md
└── skills/             # Reusable skills loaded into every session
    ├── codebase-search/
    ├── development-workflow/
    ├── rfc-writer/
    ├── wt-create/
    └── wt-close/
```

## Install

`claude/install.sh` runs after `devtools.sh` in the root `install.sh`:

- Copies `settings.json` → `~/.claude/settings.json`
- Copies `commands/` → `~/.claude/commands/`
- Copies `skills/` → `~/.claude/skills/`
- Registers MCP servers via `claude mcp add --scope user` when the Claude CLI is available

## Skills

Skills are plain SKILL.md files with optional `scripts/` subdirs. No external package manager.

Shared skills between Claude and Codex live in their respective directories and are kept in sync manually (or can be extracted to a top-level `skills/` dir with both installers copying from there if duplication becomes a maintenance burden).

### Worktree skills

`wt-create` and `wt-close` manage git worktrees:

- Default path: `worktrees/<slug>`
- Override: create `.worktree.conf` in the repo root with `WORKTREE_DIR=custom/path`

## Out of scope

- Hooks (separate plan if needed)
- Per-project `CLAUDE.md` templates (separate plan if needed)
