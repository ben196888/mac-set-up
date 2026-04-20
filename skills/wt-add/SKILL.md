---
name: wt:add
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

## Worktree Directory

Default: `worktrees/<slug>`. To override, create `.worktree.conf` in the repo root:

```
WORKTREE_DIR=custom/path
```

## Create

```bash
SLUG="<slug>"
BRANCH="worktree-${SLUG}"
REPO_ROOT="$(git rev-parse --show-toplevel)"

WORKTREE_BASE="worktrees"
CUSTOM=$(grep -E '^WORKTREE_DIR=' "${REPO_ROOT}/.worktree.conf" 2>/dev/null | cut -d= -f2-)
[ -n "$CUSTOM" ] && WORKTREE_BASE="$CUSTOM"

WORKTREE_PATH="${REPO_ROOT}/${WORKTREE_BASE}/${SLUG}"
mkdir -p "${REPO_ROOT}/${WORKTREE_BASE}"
git -C "${REPO_ROOT}" worktree add "${WORKTREE_PATH}" -b "${BRANCH}"
```

If the `EnterWorktree` tool is available, use that instead — it manages the session path automatically.

The worktree is created at `worktrees/<slug>` (or the path from `.worktree.conf`) on branch `worktree-<slug>`.

When done with the task, use `/wt:drop` to remove the worktree.
