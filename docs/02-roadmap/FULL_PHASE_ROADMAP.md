# XPS Full Phase Roadmap

## Planning assumptions
- team shape: 1 human operator plus 4 to 6 parallel AI coding lanes plus a validation lane
- quality target: production-capable MVP first, then enterprise hardening, then self-improving autonomy
- timeline estimates are AI-assisted engineering estimates, not guarantees

## Total phases
12 phases to reach a self-sufficient, self-maintaining, aggressively hardened, enterprise-grade v1 operating system.

## Estimated total time with parallel AI agent execution
- Phase 0 through Phase 4 MVP: 5 to 9 working days
- Phase 5 through Phase 8 hardened enterprise core: 2 to 4 additional weeks
- Phase 9 through Phase 12 self-maintaining and self-improving autonomy: 4 to 8 additional weeks
- Total realistic range: 6 to 12 weeks for a very strong v1, assuming focused execution and stable access to integrations

## Phase 0: Foundation and memory
Estimated time: 0.5 to 1 day

Deliverables:
- memory system
- rehydrate script
- architecture blueprint
- system map
- master checklist
- control-plane validation gate

Exit criteria:
- foundation validator passes
- repo map is current
- active build order is explicit

## Phase 1: Host repo and deployment spine
Estimated time: 0.5 to 1.5 days

Deliverables:
- Next.js host runtime
- API and worker services
- Docker local stack
- Railway service map
- GitHub Actions baseline

Exit criteria:
- local stack boots
- build/test/typecheck pass
- Railway env contract is explicit

## Phase 2: Railway-first auth and roles
Estimated time: 0.5 to 1.5 days

Deliverables:
- organization and user schema
- JWT auth
- protected routes
- employee, manager, owner, and admin access control
- onboarding profile capture

Exit criteria:
- authenticated user can sign in
- role gating works
- onboarding persists

## Phase 3: Lead ingestion and distillation path
Estimated time: 1 to 2 days

Deliverables:
- source registry
- seed registry
- crawl/search jobs
- raw observations
- parsed observations
- distillation contracts
- validation matrix integration

Exit criteria:
- manual and scheduled ingestion both work
- no raw-to-CRM bypass exists

## Phase 4: Summaries, scoring, recommendations, CRM
Estimated time: 1 to 2 days

Deliverables:
- lead summary service
- validation service
- scoring engine
- recommendation engine
- HubSpot activation path

Exit criteria:
- candidate appears in UI with summary, score, validation, recommendation
- promotion to CRM is auditable

## Phase 5: Admin control plane and editor
Estimated time: 2 to 4 days

Deliverables:
- open-lovable-inspired center editor
- preview pane
- prompt registry UI
- agent registry UI
- connector health
- source/seed manager
- autonomy controls

Exit criteria:
- admin can edit governed frontend and app files
- admin can manage prompts, connectors, and policies

## Phase 6: Role assistants and proactive operations
Estimated time: 2 to 4 days

Deliverables:
- employee assistant
- manager assistant
- owner assistant
- admin assistant
- proactive event and reminder engine
- autonomy modes and notification policies

Exit criteria:
- each role sees assistant recommendations
- allowed triggers send the right reminders and tasks

## Phase 7: Intelligence substrate and unified domain brain
Estimated time: 3 to 5 days

Deliverables:
- taxonomy completion
- benchmark packs
- seed packs
- retrieval APIs
- distillation packaging
- intelligence retrieval wiring into summaries and recommendations

Exit criteria:
- runtime uses `xps-intel` artifacts as grounding source
- freshness and provenance are visible

## Phase 8: Analytics, forecasting, simulation, benchmarking
Estimated time: 3 to 5 days

Deliverables:
- KPI dashboards
- benchmark comparisons
- pattern and trend signals
- simulation inputs and outputs
- strategy and promo recommendation surfaces

Exit criteria:
- managers and owners can see prediction and scenario outputs with inputs and assumptions

## Phase 9: Enterprise hardening
Estimated time: 4 to 7 days

Deliverables:
- secret hygiene audit
- branch protection and required checks
- backup and restore
- rollback playbooks
- dependency hygiene
- runtime budgets
- observability and alerts

Exit criteria:
- critical paths have monitoring and rollback
- no critical secret or auth risks remain open

## Phase 10: Self-healing and preventative maintenance
Estimated time: 4 to 7 days

Deliverables:
- runtime doctor
- drift detectors
- self-diagnosis jobs
- dependency update workflow
- guardrail enforcement audits
- auto-ticketing for failures

Exit criteria:
- system can detect and surface degraded states before users do

## Phase 11: Self-improving eval and reflection loop
Estimated time: 3 to 6 days

Deliverables:
- trace grading
- regression suites
- prompt and policy reflection jobs
- score quality audits
- recommendation quality audits

Exit criteria:
- every major agentic behavior is measured and can regress-fail CI

## Phase 12: Universalization and packaging
Estimated time: 5 to 10 days

Deliverables:
- tenanting and industry pack abstraction
- configuration-driven taxonomy and seed packs
- reusable control-plane templates
- franchise and multi-branch operational packs

Exit criteria:
- the system can be adapted to adjacent industries with configuration, not rewrite

## Parallel execution model

### Lane A. Runtime
- web
- api
- worker
- auth
- role pages

### Lane B. Intelligence
- taxonomy
- seeds
- benchmarks
- retrieval packs

### Lane C. Distillation
- contracts
- validators
- packaging
- confidence and freshness logic

### Lane D. Admin and editor
- editor donor integration
- prompt registry UI
- agent registry UI
- configuration and policy UIs

### Lane E. Validation and operations
- test suites
- CI/CD
- Docker
- Railway
- smoke and postdeploy checks

## Fastest launch sequence
1. lock foundation
2. stabilize host runtime
3. ship auth and role pages
4. ship stable ingestion
5. ship summaries, scores, recommendations, and HubSpot
6. ship admin/editor
7. harden the platform

## Truthful constraint
There is no honest path to literal zero risk or literal perfection. The practical ceiling is:
- zero known critical defects at release
- strict validation gates
- strong rollback
- aggressive observability
- continuous reflection and maintenance
