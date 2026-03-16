---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*)
description: Create a conventional commit from staged changes
---

## Context

- Current git status: !`git status`
- Staged and unstaged changes: !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Create a single git commit using the Conventional Commits format:

```
<type>(<optional scope>): <short description>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `style`, `perf`

Rules:
- Stage all relevant changes and commit in a single operation
- Keep the subject line under 72 characters
- Use the imperative mood ("add" not "added")
- Do not add a body unless the change is non-obvious
- Always append: `Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>`

Do not output any text — only make the tool calls to stage and commit.
