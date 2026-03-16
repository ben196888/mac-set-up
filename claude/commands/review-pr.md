---
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh pr list:*), Bash(gh pr comment:*), Bash(git log:*), Bash(git blame:*)
description: Review a pull request and post findings as a comment
argument-hint: [pr-number]
---

Review pull request $ARGUMENTS in this repository.

Steps:
1. Fetch the PR details and diff using `gh pr view $ARGUMENTS` and `gh pr diff $ARGUMENTS`
2. Check the root CLAUDE.md for project conventions
3. Review the diff for:
   - Bugs or incorrect logic
   - CLAUDE.md convention violations
   - Anything surprising given the git history of touched files
4. Post a concise comment with `gh pr comment $ARGUMENTS` only if real issues are found (score ≥ 75 confidence). Skip nitpicks and pre-existing issues.

Comment format:
```
### Code review

Found N issue(s):

1. <description> — <link to file#L1-L5>

🤖 Generated with [Claude Code](https://claude.ai/code)
```

If no issues, post:
```
### Code review

No issues found.

🤖 Generated with [Claude Code](https://claude.ai/code)
```
