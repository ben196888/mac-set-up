---
name: wt:close
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
bash .claude/skills/wt-close/scripts/cleanup-worktree.sh <slug>
```

If the `ExitWorktree` tool is available, use that with `action: remove` instead.

To pause without removing the worktree, use `ExitWorktree` with `action: keep` (or skip running the cleanup script).
