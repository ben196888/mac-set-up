# Plan: Claude Code Personal Toolkit

## Goal

Add a `claude/` directory to this repo that manages personal Claude Code configuration, making it reproducible across machines alongside the rest of the dev environment setup.

## What to add

### `claude/install.sh`

Installs Claude Code configuration into `~/.claude/` via copy (not symlink):
- `settings.json` → `~/.claude/settings.json`
- `commands/` → `~/.claude/commands/`
- `skills/` → `~/.claude/skills/`

### `claude/settings.json`

Personal Claude Code global preferences. Starts from the current `~/.claude/settings.json` and tracks changes over time.

### `claude/commands/`

Custom slash commands (`.md` files). Each file defines a reusable prompt invokable via `/command-name` in any Claude Code session.

Candidates to add:
- `/commit` — staged diff → conventional commit message
- `/review-pr` — review open PR, summarize findings
- `/simplify` — review changed code for reuse, quality, and efficiency

### `claude/skills/` ✅

Skills that shape Claude's persistent behavior across all sessions.

- `development-workflow` ✅ — 4-step dev cycle (Plan → Ask → Document → Implement)
- `search-code` ✅ — agent-optimized search strategy (rg → ast-grep → git)

## Integration

- Call `claude/install.sh` from the root `install.sh` after `devtools.sh` (step 9) ✅
- Update architecture table in `README.md` and `CLAUDE.md` to include the new `claude/` step ✅

## Out of scope

- MCP server configuration (separate plan if needed)
- Per-project `CLAUDE.md` templates (separate plan if needed)
- Hooks (separate plan if needed)
