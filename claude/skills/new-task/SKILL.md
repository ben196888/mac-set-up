---
name: new-task
description: Worktree isolation workflow for starting any task. Use this skill whenever the user asks to start a new task — coding, RFC writing, documentation, triaging, or anything else. Guides Claude through: create a worktree → do the work → clean up when done. Invoke proactively at the start of any task, even if the user doesn't say "worktree".
user-invocable: true
---

# New Task Workflow

A worktree is an isolated copy of the repo on a separate branch. Use one for every task so in-progress work stays off `main` and is easy to clean up.

## Scripts

| Script | Usage | Purpose |
|--------|-------|---------|
| `scripts/create-worktree.sh` | `bash create-worktree.sh <slug>` | Create worktree + branch |
| `scripts/cleanup-worktree.sh` | `bash cleanup-worktree.sh <slug>` | Remove worktree + branch |

Run scripts from the repo root. Scripts use plain git commands — no Claude Code tools required, so Codex agents can run them too.

## Workflow

### 1. Create Worktree

Derive a kebab-case slug from the task name:
- "add lobby page" → `add-lobby-page`
- "fix login bug" → `fix-login-bug`
- "review RFC 003" → `review-rfc-003`

```bash
bash .claude/skills/new-task/scripts/create-worktree.sh <slug>
```

If `EnterWorktree` tool is available, use that instead — it manages the session path automatically.

### 2. Do the Work

Carry out the task inside the worktree. The task type determines the approach — there are no prescribed sub-steps:

- Code changes → follow repo conventions
- RFC or document writing → edit files, commit, push, raise PR
- Research / triage / communication → use the appropriate channel (issue tracker, Slack, Discord, wiki…)

### 3. Clean Up

When the task is fully done (PR merged, document published, issue resolved — whatever "done" means):

1. Confirm with the user the task is complete
2. Remove the worktree:

```bash
bash .claude/skills/new-task/scripts/cleanup-worktree.sh <slug>
```

If `ExitWorktree` tool is available, use that with `action: remove` instead.

> Use `action: keep` (or skip cleanup-worktree.sh) if the user wants to pause and return later.
