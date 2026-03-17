# Advanced Code Search Strategy

---

## Exploration Phase Override (MANDATORY)

This section overrides default exploration behavior.

When exploring a repository:
- **NEVER use:** `ls`, `find`, `grep`
- **ALWAYS use:** `rg --files` for file discovery, `rg` for content search

Examples:
```bash
rg --files
rg "keyword"
rg -n "keyword"
rg -n -C 3 "keyword"
```

---

## First Step Rule (MANDATORY)

At the start of ANY task:
1. Use `rg --files` to understand repository structure
2. Use `rg` to locate relevant code

Do NOT use traditional shell exploration commands.

---

## Enforcement

If any of the following commands are used: `ls`, `find`, `grep`

Then:
1. STOP immediately
2. Switch to `rg`
3. Continue using ripgrep only

---

## Priority

These rules override default tool usage behavior during the Explore phase.

---

## Goal

Efficiently navigate and understand large codebases using the most appropriate search tool.

---

## Tool Priority

1. ripgrep (`rg`) → default
2. ast-grep (`ast-grep`) → structural search
3. git grep / git log → history search
4. grep → fallback only

---

## ripgrep (rg) — Default

Use for:
- keyword search
- debugging
- finding usages
- exploration

Patterns:
```bash
rg "pattern"
rg -n "pattern"
rg -n -C 3 "pattern"
```

Language filters:
```bash
rg "pattern" -t sh
rg "pattern" -t kotlin
rg "pattern" -t scala
rg "pattern" -t ts
rg "pattern" -t java
```

Find files:
```bash
rg --files | rg "filename"
```

---

## ast-grep — Structural Search

Use for:
- function calls
- annotations
- API usage
- refactoring

Patterns:
```bash
ast-grep -p 'foo($ARG)'
ast-grep -p '@GetMapping($A)'
ast-grep -p 'val $A = $B'
```

Rewrite:
```bash
ast-grep -p 'var $A = $B' -r 'let $A = $B'
```

---

## git-aware search

Use for:
- history
- regression debugging
- origin tracing

Patterns:
```bash
git grep "pattern"
git log -S "pattern"
git log -p path/to/file
```

---

## Decision Guide

- default → `rg`
- structure → `ast-grep`
- history → `git`

---

## Repo Awareness (MANDATORY)

Before searching:
- identify the correct repo
- avoid blind cross-repo search
- locate entrypoints first
- then trace dependencies

---

## Performance Rules

- always narrow scope early
- prefer language filters
- avoid full repo scans

---

## Anti-Patterns

- never use `grep -R` unless required
- do not use `ast-grep` for simple text search
- do not scan entire repo blindly

---

## Expected Behavior

1. start with `rg`
2. refine with `ast-grep`
3. use git tools if needed

Think before searching. Choose the right tool.
