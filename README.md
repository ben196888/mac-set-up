# macOS Dev Environment Setup

Automate the installation and configuration of a full macOS development environment: CLI tools, programming languages, editors, and system preferences.

---

## 📁 Architecture

`install.sh` is the orchestrator — it executes all other scripts in order:

| Step | Script | What it does |
|------|--------|-------------|
| 1 | `essential.sh` | Xcode CLT, Rosetta 2, Homebrew (auto-detects Apple Silicon vs Intel path) |
| 2 | `cli_tools.sh` | OpenSSL, ripgrep, ast-grep, tree, ack |
| 3 | `git/install.sh` | Git config, ed25519 SSH key generation, GitHub CLI auth |
| 4 | `zsh/install.sh` | Zsh, Oh My Zsh, Starship prompt |
| 5 | `terminal.sh` | Ghostty terminal |
| 6 | `languages/` | One script per language: `javascript.sh` (n + npm/yarn/pnpm/Deno), `python.sh` (pyenv + Poetry), `rust.sh`, `go.sh`, `java.sh` (SDKMAN), `dotnet.sh`, `latex.sh` |
| 7 | `ides.sh` | VS Code, Cursor |
| 8 | `browsers.sh` | Firefox (set as default), Chrome, Edge, DuckDuckGo |
| 9 | `devtools.sh` | OrbStack, kubectl, Postman, Google Cloud SDK, ChatGPT, Claude Code, Playwright CLI |
| 9.5 | `claude/install.sh` | Copies `settings.json`, `commands/`, `skills/`, and `mcp.json` into `~/.claude/` |
| 10 | `tools.sh` | AppCleaner, Spotify, Slack, Messenger, Signal, Discord, Rectangle |
| 11 | `macos.sh` | Dock (auto-hide, left), trackpad (tap-to-click, 3-finger drag, max speed), keyboard (Caps Lock→Control), input source shortcuts, Spotlight disabling |

Config files (`git/.gitconfig`, `git/.gitignore_global`, `zsh/.zshrc`) live alongside their installer scripts and are symlinked/copied during setup.

---

## 🚀 Setup Instructions

### 1. Clone this repo

```bash
git clone https://github.com/ben196888/mac-set-up.git
cd mac-set-up
```

### 2. Run the full setup

```bash
chmod +x install.sh
./install.sh
```

> Comment out any steps in `install.sh` if you only want part of the setup.

---

### 🔁 Alternative: Download ZIP and run

1. Download this repo as a ZIP from GitHub
   [Download ZIP](https://github.com/ben196888/mac-set-up/archive/refs/heads/master.zip)

2. Extract the ZIP file and navigate to the folder:
```bash
cd ~/Downloads/mac-set-up-master  # Or wherever you unzipped it
```

3. Run the installer:
```bash
chmod +x install.sh
./install.sh
```

---

## ⚙️ What It Installs

- **Zsh config**: with Starship, Oh My Zsh, and language-aware prompts
- **Git setup**: with aliases, delta, and conditional editor logic
- **VS Code + Cursor**: with settings sync and optional extension restore
- **Terminal**: Ghostty + shell utilities
- **Languages**: Go, Python, Node (via n), Rust, Java (via SDKMAN), .NET (via Homebrew), LaTeX
- **Browsers**: Firefox, Chrome, Edge, DuckDuckGo
- **Dev Tools**: OrbStack (Docker), kubectl, Postman, Google Cloud SDK, ChatGPT
- **System Preferences**: Dock, trackpad gestures, key remapping, fast repeat rate

---

## 🧠 Notes

- All `.zshrc` additions are conditional to avoid errors if tools aren't installed
- `macos.sh` applies safe `defaults write` and `hidutil` changes (some may require logout/reboot)
- You can export/import GUI app settings (like Rectangle) separately if needed

---

## 🧩 Optional Improvements

- Implement checkpoint/resume mechanism to allow interrupted installations to continue from the last successful step
- Add login item setup via `osascript` (e.g., for Rectangle)
- Add versioned `global.json` for .NET SDK pinning
- Add sync logic for VS Code extensions
- Sync Claude Code settings and custom commands via this repo

---

## 📄 License

MIT — use it, fork it, improve it.
