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
9. `xps-vision` proposes and refines strategic ideas, simulations, and invention candidates.
10. `xps-ai-factory` packages approved ideas into validated repo changes, templates, connectors, and system-in-a-box artifacts.
11. Bounded workflow sidecars (`n8n` and planned `xps-orchestrator`) execute approved automation that should not live inside canonical truth services.
12. Governed agent lanes share handoff artifacts so validation, reflection, and failover can continue without guessing.
13. Every stalled lane is resumable from the last green checkpoint through the backup/failover agent.
14. Overnight continuity runs are bounded by explicit safeguards, resumable handoff packages, and hard-stop rules rather than claims of infinite autonomy.

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
- scheduled agent prompt and handoff audit
- scheduled overnight continuity audit for rehydrate, evidence, and recovery readiness
