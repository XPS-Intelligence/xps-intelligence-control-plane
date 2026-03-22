# XPS Self-Build Loop

## Purpose
Define the exact loop that makes the platform progressively more autonomous without becoming chaotic.

## Control law
The system may automate implementation and maintenance only through governed loops.

## Canonical loop
1. GitHub Issues and GitHub Projects define work.
2. Control plane owns templates, prompts, workflows, and policy.
3. Runtime agents execute bounded implementation lanes.
4. CI runs lint, typecheck, build, unit, integration, e2e, benchmark, and smoke.
5. Evals grade summaries, scores, recommendations, and traces.
6. Failures auto-open issues and route to repair lanes.
7. Admin plane edits prompts, policies, connectors, seeds, and UI.
8. Reflection jobs update weights, prompts, tests, docs, and issue ladders.

## Guardrails
- no uncontrolled production writes
- no silent repair without audit
- no self-modifying prompt or policy changes without traceability
- high-impact runtime mutations require admin-approved policy

## Automation checkpoints
- nightly governance audit
- nightly dependency hygiene
- nightly backup verification
- nightly score and validation freshness audit
- scheduled taxonomy drift audit
- scheduled seed decay audit
- scheduled CRM sync idempotency audit
