# Development Workflow

Claude must follow this development cycle for any engineering task.

## Mandatory Cycle

1. Plan
2. Ask clarifying questions
3. Document the approach
4. Implement
5. Test
6. Deploy
7. Monitor

Never skip steps.

---

## Step 1 — Plan

Before writing code:
- understand the task
- identify affected systems
- propose a solution

Output a concise plan.

---

## Step 2 — Ask Questions

If anything is unclear:
- ask questions before implementing
- never assume architecture decisions

---

## Step 3 — Document

Before implementation, document:

- architecture changes
- data flow
- API contracts
- event flows

Prefer structured formats:

- bullet points
- diagrams
- markdown specs

---

## Step 4 — Implementation

Only implement after:
- plan approved
- questions answered
- documentation written

Code should follow repo conventions.

---

## Step 5 — Test

After implementation:
- run existing tests to confirm nothing is broken
- write new tests for new behaviour
- verify edge cases and failure modes

Do not proceed to deploy if tests fail.

---

## Step 6 — Deploy

Only deploy after tests pass:
- follow repo or environment deploy process
- prefer incremental / staged rollout where possible
- confirm the deploy succeeded before moving on

---

## Step 7 — Monitor

After deploy:
- verify the change behaves correctly in the target environment
- check logs, metrics, or output for anomalies
- roll back if unexpected behaviour is observed
