---
name: codex-programming
description: Craft a structured /codex:rescue delegation prompt that gives Codex exactly the context it needs. Use this skill whenever the user wants to hand off a task to Codex, says "delegate to codex", "prepare a codex task", "write a rescue prompt", "send to codex", or is about to invoke /codex:rescue. Also trigger when the user wants to avoid stale-context failures when switching agents, asks how to structure a Codex handoff, or mentions /codex:rescue in any planning context. Invoke proactively when the user has identified a bug or task and Codex delegation makes sense.
user-invocable: true
---

# Codex Programming

Codex starts every task cold — it has no access to this conversation's history, the errors already seen, or the architectural decisions already made. The delegation prompt is the only bridge. A vague prompt produces vague work; a tight, specific prompt produces a tight fix.

## Pre-flight checklist

Run through these before generating the prompt:

- [ ] **Commit or stash in-progress changes** — Codex sees the working tree; a half-applied diff misleads more than it helps
- [ ] **Verify AGENTS.md is current** — if the task touches an area with recent decisions, update AGENTS.md first (see [AGENTS.md guidance](#agentsmd-guidance) below)
- [ ] **Identify the 2–4 files most directly relevant** — resist listing everything

## Output

Generate the block below and present it to the user as a copyable prompt for `/codex:rescue`:

````
---
effort: medium  # low | medium | high — raise for novel/complex tasks, lower for mechanical fixes
---

## Objective
<one sentence: the exact change needed, stated as an outcome, not a process>

## Context
<only what Codex cannot derive by reading the code and git diff>
- @path/to/file — <one phrase: why this file matters>
- Error: <paste the exact error message verbatim, if applicable>
- Decision: <any non-obvious constraint or prior choice that shapes the solution>

## Constraints
<actionable rules — specific enough that violating them is unambiguous>
- Do NOT <X> because <reason>
- <architecture rule from AGENTS.md that applies to this task>
- Out of scope: <what not to touch>

## Verification
<exact shell commands that define "done" — not descriptions, runnable commands>
```bash
<command 1>
<command 2>
```
````

---

> **Continuing a task?** Use `/codex:rescue --resume <session-id>` rather than starting fresh — resuming preserves tool state and avoids re-reading the codebase from scratch.

> **Live context via MCP:** Attach external signals before delegating:
> - CI failure: paste the exact failing step into the Context section
> - Issue/ticket: include the ID and acceptance criteria
> - Discord/Slack: paste the relevant error report or decision thread

---

## Filling in each section

**Objective** — State the terminal state, not the process. "Fix the failing glob in `claude/install.sh` when `claude/skills/` is empty" not "look into the glob issue in the installer".

**Context** — Only include what Codex cannot get from `git diff` and reading the files. Exact error messages are almost always worth including verbatim. Skip anything a competent engineer would infer from the code.

**Constraints** — Draw from AGENTS.md and the current conversation. If an approach has already been ruled out ("don't use symlinks"), say so explicitly. Vague constraints ("keep it clean") waste tokens and provide no guidance.

**Verification** — If no automated tests exist, the verification is the manual command that proves the fix works. Be concrete: `bash claude/install.sh -y && ls ~/.claude/skills/` not "verify the installer works".

## AGENTS.md guidance

Apply this test to each AGENTS.md line before delegating: *could a reviewer cite a specific code change as violating this rule?* If not, cut it or rewrite it.

**Good — specific and falsifiable:**
```
Always use cp, never ln -s or ln -sf. Install scripts must copy files to their destination.
Worktrees go in worktrees/ by default; override with .worktree.conf WORKTREE_DIR=custom/path.
Skills loop must handle empty glob patterns — use nullglob or an existence check before iterating.
```

**Bad — vague and unactionable:**
```
Write clean, maintainable shell scripts.
Follow best practices when working with the installer.
Keep the codebase organized.
```

Every AGENTS.md constraint should name the rule, state what it prohibits or requires, and explain why — so Codex can apply it to edge cases the rule author didn't anticipate.
