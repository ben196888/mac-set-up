---
name: wt:find
description: Find and recover a git worktree from partial context — branch fragment, path fragment, recently edited file, or a vague description like "stripe refactor" or "the auth thing from last week". Use whenever the user says "find my worktree", "where's my branch for X", "I was working on something about Y", "which worktree has Z", or can't remember which worktree they need. Always use this skill before resorting to manual `git worktree list` when the user has a vague or partial description.
user-invocable: true
---

# Find Worktree

Recovers the right worktree when the user only has partial context about what they were working on.

## Step 1: Gather context

Run these commands from the repo root to build a full picture:

```bash
# All worktrees with metadata
git worktree list --porcelain

# Per worktree — run for each path from the porcelain output
git -C <path> log --format="%h %ar %s" -10 2>/dev/null
git -C <path> status --short 2>/dev/null
```

The porcelain output gives you: `worktree <path>`, `HEAD <hash>`, `branch refs/heads/<name>` (or `detached`).

Collect for each worktree:
- Absolute path
- Branch name (strip `refs/heads/`)
- Last 10 commit summaries with relative timestamps
- Dirty file list (names only, not full diff)

## Step 2: Match against the query

Reason over the gathered context. The user's query can be any of:

| Query type | What to match against |
|---|---|
| Branch fragment | Branch name (e.g. `stripe` → `worktree-stripe-refactor`) |
| Path fragment | Worktree path |
| Filename | Dirty file list, commit messages |
| Description | Commit messages and branch name semantically |
| Time reference | Relative timestamps from `git log` (e.g. "last week") |

Use your judgment — partial matches, synonyms, and semantic similarity all count. A branch called `worktree-fix-jwt-expiry` is a strong match for "the auth thing".

## Step 3: Output ranked results

Format results as a numbered ranked list, most likely match first:

```
1. worktrees/stripe-refactor  [branch: worktree-stripe-refactor]  ← best match
   Last commit: abc1234  fix payment webhook handler  (2 days ago)
   Dirty: src/payments.ts, tests/webhook.test.ts

2. worktrees/payments-v2  [branch: worktree-payments-v2]
   Last commit: def5678  add Stripe SDK  (5 days ago)
   Clean
```

Then ask the user to confirm: "Switch to #1, or pick another?"

**Single match**: confirm directly without making the user pick.  
**No matches**: say so and show all worktrees as a plain list so the user can scan manually.

## Step 4: Navigate

Once the user confirms, provide the `cd` command for the target path:

```bash
cd <worktree-path>
```

If the `EnterWorktree` tool is available, use that with `action: enter` instead — it handles the session path automatically.
