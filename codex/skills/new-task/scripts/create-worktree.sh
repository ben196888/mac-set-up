#!/usr/bin/env bash
set -euo pipefail

# Usage: create-worktree.sh <slug>
# Creates a git worktree at .claude/worktrees/<slug> on branch worktree-<slug>

if [ $# -ne 1 ]; then
  echo "Usage: $0 <slug>" >&2
  exit 1
fi

SLUG="$1"
BRANCH="worktree-${SLUG}"
REPO_ROOT="$(git rev-parse --show-toplevel)"
WORKTREE_PATH="${REPO_ROOT}/.claude/worktrees/${SLUG}"

mkdir -p "${REPO_ROOT}/.claude/worktrees"
git -C "${REPO_ROOT}" worktree add "${WORKTREE_PATH}" -b "${BRANCH}"

echo "✓ Created worktree at .claude/worktrees/${SLUG}"
echo "  Branch: ${BRANCH}"
