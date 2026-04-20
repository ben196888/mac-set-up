#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Run essential setup (Xcode, Rosetta, Homebrew)
source "$SCRIPT_DIR/essential.sh"

# Install cli tools (openSSL, rg, tree, ack, nmap)
bash "$SCRIPT_DIR/cli_tools.sh"
# Setup git config and ssh
bash "$SCRIPT_DIR/git/install.sh"
# Install zsh, oh my zsh, plugins, starship
bash "$SCRIPT_DIR/zsh/install.sh"
# Install terminal apps (ghostty)
bash "$SCRIPT_DIR/terminal.sh"

# Install languages (rust, java, node, deno, python, latex, go)
bash "$SCRIPT_DIR/languages/dotnet.sh"
bash "$SCRIPT_DIR/languages/go.sh"
bash "$SCRIPT_DIR/languages/java.sh"
bash "$SCRIPT_DIR/languages/javascript.sh"
bash "$SCRIPT_DIR/languages/latex.sh"
bash "$SCRIPT_DIR/languages/python.sh"
bash "$SCRIPT_DIR/languages/rust.sh"

# Install IDEs (VSCode, IntelliJ, Android Studio)
bash "$SCRIPT_DIR/ides.sh"
# Install browsers (firefox, chrome, edge, duckduckgo)
bash "$SCRIPT_DIR/browsers.sh"
# Install developer tools (orbstack, kubectl, postman, google cloud SDK)
bash "$SCRIPT_DIR/devtools.sh"
# Setup Claude Code configuration (settings, custom commands)
bash "$SCRIPT_DIR/claude/install.sh"
# Setup Codex configuration (skills, MCP)
bash "$SCRIPT_DIR/codex/install.sh"
# Install other tools
bash "$SCRIPT_DIR/tools.sh"

# Setup macOS preferences
bash "$SCRIPT_DIR/macos.sh"
