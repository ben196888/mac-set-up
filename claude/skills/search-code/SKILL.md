# Prefer ripgrep over grep for code search

## Purpose

When searching code in repositories, always prefer `rg` (ripgrep) instead of `grep` because it is significantly faster and respects `.gitignore`.

## Rules

- Use `rg` instead of `grep`
- Only fall back to `grep` if `rg` is unavailable
- Always show line numbers and context
- Filter by language type when possible

## Recommended patterns

Search text:
```bash
rg "pattern"
```

Search with line numbers:
```bash
rg -n "pattern"
```

Search with context:
```bash
rg -n -C 3 "pattern"
```

Search filenames:
```bash
rg --files | rg "filename"
```

Language-specific searches:
```bash
rg "pattern" -t sh
rg "pattern" -t json
rg "pattern" -t ts
rg "pattern" -t kotlin
rg "pattern" -t java
```

## Never use

```bash
grep -R
```

unless `rg` is unavailable.
