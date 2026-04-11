---
name: wt:create
description: Create a git worktree for a new task. Derives a kebab-case slug from the task name, creates a branch, and sets up an isolated working directory. Invoke at the start of any task that needs branch isolation.
user-invocable: true
---

# Create Worktree

Creates an isolated copy of the repo on a new branch so in-progress work stays off `main`.

## Slug Derivation

Derive a kebab-case slug from the task name:
- "add lobby page" → `add-lobby-page`
- "fix login bug" → `fix-login-bug`
- "review RFC 003" → `review-rfc-003`

## Create

```bash
bash .claude/skills/wt-create/scripts/create-worktree.sh <slug>
```

If the `EnterWorktree` tool is available, use that instead — it manages the session path automatically.

The worktree is created at `.claude/worktrees/<slug>` on branch `worktree-<slug>`.

When done with the task, use `/wt:close` to remove the worktree.
