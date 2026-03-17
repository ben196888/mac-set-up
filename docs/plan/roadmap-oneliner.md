# Roadmap: One-liner curl Installation

## Goal

Make the full setup bootstrappable with a single command on a fresh Mac:

```bash
curl -fsSL https://raw.githubusercontent.com/ben196888/mac-set-up/master/install.sh | sh
```

No cloning, no unzipping, no `chmod`. Just one line.

---

## Why it's not ready yet

The current `install.sh` uses relative paths to call sibling scripts (`./cli_tools.sh`, `./git/install.sh`, etc). When piped through `curl | sh`, there is no working directory with those files — the script runs in isolation and immediately fails.

---

## What needs to change

### 1. Self-contained bootstrap entry point

Create a `bootstrap.sh` (or make `install.sh` curl-safe) that:
- Detects if running via `curl | sh` (no local files present)
- Clones the repo to a temp directory (`/tmp/mac-set-up`)
- `cd`s into it and runs `install.sh` from there

Example pattern:
```bash
REPO="https://github.com/ben196888/mac-set-up.git"
INSTALL_DIR="/tmp/mac-set-up"

if [ ! -d "$INSTALL_DIR" ]; then
  git clone --depth 1 "$REPO" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR" && bash install.sh
```

### 2. Git must be available before cloning

On a fresh Mac, `git` triggers the Xcode CLT install prompt. Options:
- **A** — instruct the user to accept the Xcode CLT prompt before running the one-liner
- **B** — use the GitHub ZIP download API instead of `git clone` (no git required)
- **C** — install Homebrew first via its own one-liner, then `brew install git`, then clone

Option C aligns with how `essential.sh` already works and is the most reliable.

### 3. Idempotency audit

Before enabling the one-liner, all scripts must be safe to re-run:
- Each `brew install` should be guarded or rely on Homebrew's built-in idempotency
- SSH key generation, GitHub CLI auth, and other interactive steps need skip guards

### 4. README update

Replace the current multi-step setup instructions with:
```bash
curl -fsSL https://raw.githubusercontent.com/ben196888/mac-set-up/master/bootstrap.sh | sh
```

---

## Out of scope (separate plans)

- Checkpoint/resume for interrupted installs
- Selective install (install only languages, only tools, etc.)
- Version pinning for installed tools
