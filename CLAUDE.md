# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Does

This is a macOS development environment automation tool. Running `./install.sh` sets up a complete dev environment in one shot: Homebrew, CLI tools, languages, IDEs, browsers, productivity apps, and system preferences.

## Running

```bash
chmod +x install.sh
./install.sh
```

Individual scripts can also be run directly (e.g., `./languages/python.sh`).

There are no build, lint, or test commands — this is a shell-based installer with no test suite.

## Architecture

`install.sh` is the orchestrator — it sources or executes all other scripts in order:

1. **`essential.sh`** — Xcode CLT, Rosetta 2, Homebrew (with Apple Silicon vs Intel path detection via `uname -m`)
2. **`cli_tools.sh`** — OpenSSL, ripgrep, tree, ack
3. **`git/install.sh`** — Git config, ed25519 SSH key generation, GitHub CLI auth
4. **`zsh/install.sh`** — Zsh, Oh My Zsh, Starship prompt
5. **`terminal.sh`** — Ghostty terminal
6. **`languages/`** — One script per language: `javascript.sh` (n + npm/yarn/pnpm/Deno), `python.sh` (pyenv + Poetry), `rust.sh`, `go.sh`, `java.sh` (SDKMAN), `dotnet.sh`, `latex.sh`
7. **`ides.sh`** — VS Code, Cursor
8. **`browsers.sh`** — Firefox (default), Chrome, Edge, DuckDuckGo
9. **`devtools.sh`** — OrbStack, kubectl, Postman, Google Cloud SDK, ChatGPT, Claude Code
10. **`tools.sh`** — AppCleaner, Spotify, Slack, Messenger, Signal, Discord, Rectangle, Raycast
11. **`macos.sh`** — System defaults: Dock (auto-hide, left position), trackpad (tap-to-click, 3-finger drag, max speed), keyboard (Caps Lock→Control), input source shortcuts, Spotlight disabling

## Key Conventions

- **Homebrew prefix**: Always use the `BREW_PREFIX` variable (set in `essential.sh` based on arch) rather than hardcoding paths. `/opt/homebrew` on Apple Silicon, `/usr/local` on Intel.
- **Conditional tool init in `.zshrc`**: All tool initializations (pyenv, Poetry, SDKMAN, etc.) are wrapped in `command -v <tool> >/dev/null 2>&1` guards so the shell doesn't break if a tool isn't installed.
- **Config files live alongside installers**: `git/.gitconfig` and `git/.gitignore_global` are symlinked/copied by `git/install.sh`; `zsh/.zshrc` is managed by `zsh/install.sh`.
