# XPS Enterprise Benchmark Matrix

## Purpose
Define the quality bars required for a FAANG-style, enterprise-grade autonomous B2B/SaaS platform.

## GitHub operating benchmark
- mono-repo or multi-repo responsibilities are explicit
- `README`, architecture, environment, testing, deployment, and issue ladder docs exist
- branch protection enabled on `main`
- required checks enabled
- CODEOWNERS or ownership map exists
- secret scanning enabled
- Dependabot or equivalent dependency hygiene exists
- issues and projects map to roadmap phases
- reusable workflows are used where sensible

## CI/CD benchmark
- lint
- typecheck
- build
- unit tests
- integration tests
- e2e benchmark
- postdeploy smoke
- dependency vulnerability gate
- artifact retention or deployment logs
- rollback procedure documented

## Runtime benchmark
- Docker-local stack works
- Railway deploy contract is explicit
- startup command, port, env, and health behavior are documented
- health/readiness endpoints exist
- structured logging exists
- critical paths have retries and dead-letter or equivalent failure surfacing

## Auth and RBAC benchmark
- app-owned auth or equivalent is coherent
- roles are explicit
- permissions are deny-by-default
- session invalidation path exists
- onboarding profile is versioned
- admin-only functions are enforced in both UI and API

## Data benchmark
- canonical relational truth store exists
- migrations are explicit and repeatable
- provenance is captured
- validation state is captured
- freshness is captured
- CRM activation is auditable
- destructive writes are bounded and explicit

## AI and agent benchmark
- tools are allowlisted
- prompts are versioned
- skills are versioned
- autonomy modes exist
- high-impact actions are gated
- traces are logged
- evals exist for summaries, scoring, and recommendations
- fallback and timeout behavior exists

## Scraper and ingestion benchmark
- source registry exists
- seed registry exists
- manual search path exists
- scheduled path exists
- validation path exists
- dedupe path exists
- no raw evidence bypasses distillation into CRM

## Product benchmark
- employee page works
- manager page works
- owner page works
- admin page works
- lead summary works
- lead validation works
- lead scoring works
- recommendation flow works
- CRM sync works
- email/calendar/task flow works

## Admin control plane benchmark
- center editor exists
- preview exists
- prompt library exists
- agent settings exist
- autonomy settings exist
- connector health exists
- source and seed settings exist
- cost and usage visibility exists
- emergency stop exists

## Benchmark gates by severity

### Release-blocking
- auth breakage
- missing health path
- failed migration path
- no rollback
- unbounded destructive action
- CRM activation without audit
- summary or score path without provenance

### Harden-before-scale
- flaky e2e
- missing cost controls
- missing alerting
- missing backup verification
- stale seed or taxonomy sync

### Optimize-next
- simulation depth
- advanced forecasting
- higher-order personalization
- multi-tenant industry packaging
