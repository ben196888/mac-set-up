---
name: "codebase-search"
description: "Use when exploring a repository so code search stays fast and precise."
---

# Advanced Code Search Strategy

## Defaults

- Use `rg --files` for file discovery.
- Use `rg` for text search.
- Use `ast-grep` for structural search when plain text search is not enough.
- Use `git grep` or `git log` for history-oriented investigation.

## Exploration workflow

1. Start with `rg --files` to understand the repository layout.
2. Use `rg -n` to locate the relevant code paths.
3. Narrow scope early with file globs or language filters.
4. Switch to structural or history-aware tools only when needed.

## Avoid

- `grep -R` for normal repository exploration
- broad scans without narrowing scope
- using structural search when a plain text search will do
