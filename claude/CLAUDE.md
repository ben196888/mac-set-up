# Global Claude Code Instructions

These personal preferences apply to all projects.

## Git Commit Convention

Always use Conventional Commits format:

```
<type>(<optional scope>): <short description>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `style`, `perf`

Rules:
- Keep the subject line under 72 characters
- Use the imperative mood ("add" not "added")
- Do not add a body unless the change is non-obvious

## Commit Frequency

Commit often — one commit per small-scope change. Do not batch unrelated changes into a single commit. Granular commits are easier to review, revert, and bisect.

## Fixup / Squash for Typos

When fixing typos, syntax errors, or minor corrections for a commit on the same branch, use `git commit --fixup <sha>` or `git commit --squash <sha>` referencing the original commit. Never amend, fixup, or squash on protected branches: `main`, `master`, `develop` (GitLab Flow).

## Codebase Search

Use the right tool for the job when searching code:

1. **`rg`** (ripgrep) — default for all text search, file discovery (`rg --files`), and exploration. Use language filters (`-t sh`, `-t ts`, etc.) to narrow scope early.
2. **`ast-grep`** — structural/AST search for function calls, annotations, API usage, and refactoring patterns (e.g., `ast-grep -p 'foo($ARG)'`).
3. **`git grep` / `git log -S`** — history-oriented search for regression debugging and origin tracing.

Avoid `grep -R`, `find`, and `ls` for code exploration. Do not use `ast-grep` when plain text search suffices. Always narrow scope before scanning.
