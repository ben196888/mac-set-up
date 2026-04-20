---
name: wt:drop
description: Clean up a git worktree after a task is complete. Removes the worktree directory and branch. Invoke when the task is fully done (PR merged, issue resolved, etc.).
user-invocable: true
---

# Close Worktree

Removes the worktree and its branch once a task is fully complete.

## When to Use

Only close when the task is truly done — PR merged, document published, issue resolved. If the user wants to pause and return later, skip cleanup or use `action: keep`.

## Close

Confirm with the user that the task is complete, then:

```bash
SLUG="<slug>"
BRANCH="worktree-${SLUG}"
REPO_ROOT="$(git rev-parse --show-toplevel)"

WORKTREE_BASE="worktrees"
CUSTOM=$(grep -E '^WORKTREE_DIR=' "${REPO_ROOT}/.worktree.conf" 2>/dev/null | cut -d= -f2-)
[ -n "$CUSTOM" ] && WORKTREE_BASE="$CUSTOM"

WORKTREE_PATH="${REPO_ROOT}/${WORKTREE_BASE}/${SLUG}"
git -C "${REPO_ROOT}" worktree remove "${WORKTREE_PATH}" --force
git -C "${REPO_ROOT}" branch -d "${BRANCH}" 2>/dev/null || git -C "${REPO_ROOT}" branch -D "${BRANCH}"
git -C "${REPO_ROOT}" worktree prune
```

If the `ExitWorktree` tool is available, use that with `action: remove` instead.

To pause without removing the worktree, use `ExitWorktree` with `action: keep` (or skip the cleanup).
