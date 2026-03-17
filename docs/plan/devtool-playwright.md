# Plan: Playwright CLI

## Goal

Install Playwright CLI globally for browser automation and testing.

## Approach

- Added to `devtools.sh` (step 9), after Node.js is available from `languages/javascript.sh` (step 6)
- No `brew install node` guard — relies on `n` version manager from `languages/javascript.sh`
- Idempotent: skips install if `playwright` command already exists

## Commands

```bash
if ! command -v playwright >/dev/null 2>&1; then
  npm install -g playwright
  npx playwright install
fi
```

## Out of scope

- Playwright MCP (using CLI only)
- Per-project config
