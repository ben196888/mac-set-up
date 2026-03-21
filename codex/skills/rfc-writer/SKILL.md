---
name: "rfc-writer"
description: "Use when a requested change is cross-cutting, architectural, or needs alignment before implementation."
---

# RFC Writer

Write an RFC before implementation when a change affects multiple systems, introduces breaking contracts, or requires architectural alignment.

## Location

Create RFCs at:

```text
docs/rfc/<slug>.md
```

Use a short, lowercase, hyphenated slug.

## Status

Every RFC must include:

```text
Status: Draft | In Review | Approved | Implemented
```

## Template

```markdown
# RFC: <Title>

Status: Draft

## Problem

What is the problem and why does it matter?

## Goals

- Goal

## Non-goals

- Out of scope

## Proposal

Describe the chosen approach, including architecture, data flow, interfaces, and rollout.

## Alternatives Considered

| Option | Pros | Cons | Why rejected |
|--------|------|------|--------------|
| ...    | ...  | ...  | ...          |

## Impact

- Systems affected
- Breaking changes
- Rollout plan
- Risks and rollback strategy

## Open Questions

- [ ] Outstanding question

## Timeline / Milestones

| Milestone | Target |
|-----------|--------|
| RFC approved | -- |
| Implementation start | -- |
| Feature complete | -- |
```
