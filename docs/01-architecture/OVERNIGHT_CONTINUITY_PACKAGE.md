# XPS Overnight Continuity Package

## Purpose
Define a practical overnight operating model for XPS that supports:
- startup rehydrate
- recurring validation, build, and deploy loops
- bounded failure recovery
- backup-agent handoff
- explicit safeguards

This package does not claim infinite autonomy.
It defines how to continue safely for a bounded unattended window while preserving evidence, rollback safety, and a clear handoff.

## Scope
The overnight package applies to:
- `xps-intelligence-control-plane`
- `xps-intelligence-system`
- `xps-intel`
- `xps-distallation-system`
- `xps-google-workspace-bridge`
- `xps-ai-factory`
- `xps-vision`

## Non-goals
- unattended destructive changes
- silent production mutations
- autonomous scope expansion
- unbounded recursive loops
- claiming success without validation evidence

## Continuity windows
### Window A: local-only continuity
Use when the agent is allowed to:
- inspect repos
- edit code and docs
- launch Docker
- run tests
- generate artifacts
- commit and push to GitHub

Do not deploy from this window unless the target repo is already linked and the deploy contract is explicit.

### Window B: deployment continuity
Use only when all of the following are true:
- Railway project is linked
- build and start contracts are explicit
- env contract is current
- postdeploy smoke exists
- rollback path is documented

### Window C: recovery-only continuity
Use when the active lane is unhealthy.
This window is restricted to:
- gathering evidence
- restoring the last green checkpoint
- re-running validation
- preparing backup-agent takeover

## Startup rehydrate sequence
1. Read `C:\XPS\AGENTS.md`.
2. Read `C:\XPS\xps-intelligence-control-plane\docs\07-prompts\PLATFORM_MEMORY.md`.
3. Read `C:\XPS\xps-intelligence-control-plane\docs\07-prompts\MASTER_INVOCATION_PROMPT.md`.
4. Read `C:\XPS\xps-intelligence-control-plane\docs\01-architecture\ENTERPRISE_AUTONOMY_BLUEPRINT.md`.
5. Read `C:\XPS\xps-intelligence-control-plane\docs\01-architecture\FULL_STACK_SPEC.md`.
6. Read `C:\XPS\xps-intelligence-control-plane\docs\02-roadmap\FULL_PHASE_ROADMAP.md`.
7. Read `C:\XPS\xps-intelligence-control-plane\docs\03-checklists\MASTER_BUILD_CHECKLIST.md`.
8. Read `C:\XPS\xps-intelligence-control-plane\docs\03-checklists\ENTERPRISE_BENCHMARK_MATRIX.md`.
9. Inspect the active repo reality:
   - git status
   - recent commits
   - package manager and lockfile
   - Docker and Railway config
   - CI workflows
   - env contracts
10. Resume only from the last verified checkpoint.

## Overnight execution loop
1. Rehydrate.
2. Confirm active milestone and repo.
3. Inspect local repo truth and external deploy linkage.
4. Determine the smallest high-value bounded slice.
5. Implement.
6. Run static validation.
7. Run build validation.
8. Run runtime validation.
9. Run integration, e2e, and headful validation where applicable.
10. If all required validation is green:
    - commit in a clean slice
    - push to GitHub
11. Deploy only if Window B conditions are satisfied.
12. Run postdeploy smoke if deployed.
13. Write handoff evidence.
14. Continue only if:
    - the next step is within the same milestone
    - risk stays below the overnight safeguard threshold
    - there is still a clear validation path

## Recurring validation, build, and deploy loop
### Required recurring checks
- lint
- typecheck
- schema and env validation
- dependency sanity
- local build
- Docker build
- runtime health and readiness
- smoke or e2e on critical routes
- headful validation for UI-impacting changes
- benchmark checks where the route is performance-sensitive

### Promotion rule
Do not promote a commit to deployable status unless:
- the required validation set for that change passed
- evidence is captured
- no open failure at a lower validation level is ignored

### Deploy rule
Deploy is allowed only when:
- repo is linked to Railway
- service config is explicit
- required env vars are known
- postdeploy smoke exists
- rollback notes exist

## Failure recovery protocol
### Recoverable failures
- local build failure
- Docker startup failure
- health check failure
- e2e regression
- headful validation mismatch
- workflow syntax failure
- broken migration on a local validation database

### Recovery order
1. Preserve evidence.
2. Stop scope expansion.
3. Restore the last green checkpoint if needed.
4. Fix the smallest root cause.
5. Re-run the failed validation level.
6. Re-run dependent higher levels.
7. Update runbook, checklist, or contract if the failure exposed a missing guardrail.

### Hard-stop failures
The overnight lane must stop and hand off if any of the following happens:
- secrets or credentials are at risk
- destructive production changes would be required
- deploy target identity is ambiguous
- multiple recovery attempts produce conflicting results
- external provider state cannot be verified

## Backup-agent handoff contract
Every overnight lane must end with a handoff package containing:
- active repo
- active milestone
- last green commit
- current branch
- current git status
- exact commands run
- exact validation results
- artifact paths
- deploy state
- remaining blockers
- next recommended action

Backup takeover must:
1. read platform memory
2. read this continuity package
3. read the agent operation runbook
4. read the backup failover prompt
5. inspect the last validation evidence
6. resume only from the last green checkpoint

## Safeguards
### Scope safeguards
- one active milestone at a time
- no implicit cross-repo rewrites
- no opportunistic architecture rewrites during recovery

### Validation safeguards
- no green claim without actual command output
- no skipped validation without a stated reason
- no deploy claim without postdeploy verification

### Change safeguards
- prefer small commit slices
- preserve rollback points
- do not mix infra, product, and recovery changes unless necessary

### Deployment safeguards
- Railway deploys require linked project confirmation
- production env changes must be explicit and documented
- postdeploy smoke is mandatory

### Agent safeguards
- backup agent continues scope; it does not redefine scope
- failover is continuity, not reinvention
- if evidence is incomplete, the lane is not resumable and must stop

## Minimum overnight evidence package
- command transcript summary
- validation matrix summary
- artifact locations
- current git diff status
- pushed commit IDs
- deploy status
- open risks
- exact next step

## Success condition
The overnight package is functioning when an agent can:
- rehydrate quickly
- execute a bounded validated slice
- recover from common failures
- hand off cleanly to a backup agent
- stop safely when the risk boundary is crossed
