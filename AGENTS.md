# AGENTS.md

This file provides guidance to Codex when working with code in this repository.

## What This Repo Does

This is a macOS development environment automation tool. Running `./install.sh` sets up a complete dev environment in one shot: Homebrew, CLI tools, languages, IDEs, browsers, productivity apps, AI coding tools, and system preferences.

## Running

```bash
chmod +x install.sh
./install.sh
```

Individual scripts can also be run directly, for example `./languages/python.sh` or `./codex/install.sh`.

There are no build, lint, or test commands. This is a shell-based installer with no automated test suite.

## Architecture

`install.sh` is the orchestrator and executes the other scripts in order:

1. **`essential.sh`** - Xcode CLT, Rosetta 2, Homebrew with Apple Silicon vs Intel path detection
2. **`cli_tools.sh`** - OpenSSL, ripgrep, ast-grep, tree, ack
3. **`git/install.sh`** - Git config, ed25519 SSH key generation, GitHub CLI auth
4. **`zsh/install.sh`** - Zsh, Oh My Zsh, Starship prompt
5. **`terminal.sh`** - Ghostty terminal
6. **`languages/`** - Per-language setup scripts for .NET, Go, Java, JavaScript, LaTeX, Python, Rust
7. **`ides.sh`** - VS Code, Cursor
8. **`browsers.sh`** - Firefox, Chrome, Edge, DuckDuckGo
9. **`devtools.sh`** - OrbStack, kubectl, Postman, Google Cloud SDK, ChatGPT, Claude Code, Playwright CLI
10. **`claude/install.sh`** - Copies Claude settings, commands, and skills into `~/.claude/`; registers MCP servers
11. **`codex/install.sh`** - Copies Codex skills into `~/.codex/skills/`; registers MCP servers
12. **`tools.sh`** - AppCleaner, Spotify, Slack, Messenger, Signal, Discord, Rectangle
13. **`macos.sh`** - System defaults such as Dock, trackpad, keyboard, and Spotlight configuration

## Key Conventions

- Always use the `BREW_PREFIX` variable from `essential.sh` instead of hardcoding Homebrew paths.
- Config files live alongside their installers and are copied into place. Do not switch this repo to symlink-based setup.
- Shell profile additions should be conditional so a missing tool does not break the shell.
- Prefer `cp` and `cp -r` for installation steps.
