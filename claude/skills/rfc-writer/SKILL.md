# RFC Writer

## Purpose

When a task is large or cross-cutting, write an RFC before implementation.
RFCs capture the problem, the chosen approach, and decisions made — so the
team can align before work begins.

---

## When to Write an RFC

Write an RFC when the change involves any of:
- multiple systems or services affected
- breaking changes or new API contracts
- significant architectural decisions
- changes requiring team alignment or sign-off

For small, self-contained changes, inline documentation is sufficient.

---

## RFC Location

Always create RFCs at:

```
docs/rfc/<slug>.md
```

Use a short, lowercase, hyphenated slug that describes the change.
Example: `docs/rfc/discord-mcp-integration.md`

---

## Status Lifecycle

Every RFC must include a status line at the top:

```
Status: Draft | In Review | Approved | Implemented
```

- **Draft** — being written, not ready for review
- **In Review** — shared for feedback, open for comments
- **Approved** — decision made, ready to implement
- **Implemented** — work complete, RFC archived for reference

---

## RFC Template

```markdown
# RFC: <Title>

Status: Draft

## Problem

What is the problem being solved, and why does it matter?
Include context, current pain points, and impact if left unresolved.

## Goals

- What this RFC aims to achieve
- Measurable outcomes where possible

## Non-goals

- What is explicitly out of scope
- What will not be addressed by this change

## Proposal

The chosen approach. Be specific:
- architecture changes
- data flow
- API contracts
- event flows
- component interactions

Use diagrams, bullet points, or markdown specs.

## Alternatives Considered

| Option | Pros | Cons | Why rejected |
|--------|------|------|--------------|
| ...    | ...  | ...  | ...          |

## Impact

- **Systems affected**: list services, repos, or components
- **Breaking changes**: APIs, contracts, data schemas
- **Rollout plan**: phased, feature-flagged, or big-bang
- **Risks**: known unknowns, failure modes, rollback strategy

## Open Questions

- [ ] Question that needs resolution before approval
- [ ] Dependency or decision pending from another team

## Timeline / Milestones

| Milestone | Target |
|-----------|--------|
| RFC approved | — |
| Implementation start | — |
| Feature complete | — |
| Deployed to production | — |
```

---

## Rules

- Always use the template above — do not omit sections
- Keep the Problem and Proposal sections concise and scannable
- Update the Status field as the RFC progresses
- Link to the RFC from the relevant plan doc or issue
