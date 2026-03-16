#!/bin/bash
set -e

# Run essential setup (Xcode, Rosetta, Homebrew)
source ./essential.sh

# Install cli tools (openSSL, rg, tree, ack, nmap)
./cli_tools.sh
# Setup git config and ssh
./git/install.sh
# Install zsh, oh my zsh, plugins, starship
./zsh/install.sh
# Install terminal apps (ghostty)
./terminal.sh

# Install languages (rust, java, node, deno, python, latex, go)
./languages/dotnet.sh
./languages/go.sh
./languages/java.sh
./languages/javascript.sh
./languages/latex.sh
./languages/python.sh
./languages/rust.sh

# Install IDEs (VSCode, IntelliJ, Android Studio)
./ides.sh
# Install browsers (firefox, chrome, edge, duckduckgo)
./browsers.sh
# Install developer tools (orbstack, kubectl, postman, google cloud SDK)
./devtools.sh
# Setup Claude Code configuration (settings, custom commands)
./claude/install.sh
# Install other tools
./tools.sh

# Setup macOS preferences
./macos.sh
