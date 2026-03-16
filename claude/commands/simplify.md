---
allowed-tools: Read, Edit, Bash(git diff:*)
description: Simplify recently changed code for reuse, quality, and efficiency
---

## Context

Changed files: !`git diff --name-only HEAD`

## Your task

Review the changed code and fix any issues found. Focus only on:
- Redundant logic or unnecessary complexity that can be simplified
- Obvious inefficiencies (e.g. repeated lookups, unnecessary allocations)
- Duplicate code that can be consolidated without over-abstracting

Do not:
- Refactor code that was not changed
- Add comments, docstrings, or type annotations
- Introduce abstractions for one-off cases
- Change behaviour

Edit the files directly. Do not summarize what you changed.
