#!/usr/bin/env bash
set -euo pipefail

# Usage: cleanup-worktree.sh <slug>
# Removes the git worktree at .claude/worktrees/<slug> and deletes the branch

if [ $# -ne 1 ]; then
  echo "Usage: $0 <slug>" >&2
  exit 1
fi

SLUG="$1"
BRANCH="worktree-${SLUG}"
REPO_ROOT="$(git rev-parse --show-toplevel)"
WORKTREE_PATH="${REPO_ROOT}/.claude/worktrees/${SLUG}"

git -C "${REPO_ROOT}" worktree remove "${WORKTREE_PATH}" --force
git -C "${REPO_ROOT}" branch -d "${BRANCH}" 2>/dev/null || git -C "${REPO_ROOT}" branch -D "${BRANCH}"
git -C "${REPO_ROOT}" worktree prune

echo "✓ Removed worktree .claude/worktrees/${SLUG}"
echo "✓ Deleted branch ${BRANCH}"
