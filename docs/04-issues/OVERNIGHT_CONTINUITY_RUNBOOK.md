# Overnight Continuity Runbook

## Purpose
Give the overnight lane an explicit operating checklist that can be followed without inventing process mid-run.

## Before the overnight run
- confirm the active repo
- confirm the active milestone
- confirm whether deploy is in scope
- confirm the repo is in a resumable state
- confirm the Railway linkage state if deploy is expected
- confirm the last green checkpoint is known

## Startup checklist
1. Run the workspace rehydrate sequence.
2. Inspect git status.
3. Inspect the last two or three commits.
4. Inspect Docker, Railway, CI, and env contracts.
5. Identify the next bounded slice.
6. Record the intended validation set before editing.

## Standard overnight loop
1. implement the bounded slice
2. run static validation
3. run build validation
4. run runtime validation
5. run smoke, e2e, benchmark, or headful validation as required
6. if green, commit in a clean slice
7. push to GitHub
8. deploy only if deploy rules are satisfied
9. run postdeploy smoke if deployed
10. write the handoff package

## When to stop
Stop the overnight lane and prepare handoff if:
- the next step would be destructive
- the external provider state cannot be verified
- the repo enters a conflicting or ambiguous state
- the validation path is unclear
- the recovery loop stops producing new information

## Recovery checklist
1. capture the exact failure
2. capture the failing command
3. capture affected files
4. stop unrelated edits
5. fix the smallest root cause
6. rerun the failed layer
7. rerun dependent layers
8. document the lesson if a guardrail was missing

## Backup handoff checklist
- active repo
- active milestone
- current branch
- last green commit
- current dirty files
- current failing command if any
- exact validation status
- artifact paths
- deploy state
- next recommended step

## Required safeguards
- no hidden production writes
- no deploy without linked-project certainty
- no merge claim without workflows green
- no health claim without runtime proof
- no UI claim without route validation when UI changed

## Recommended overnight artifacts
- screenshots for changed UI routes
- trace or video for headful validation
- benchmark output for performance-sensitive flows
- logs for startup and failure recovery

## Morning handoff format
Use a concise status note with:
- what changed
- what validated
- what was pushed
- whether deploy happened
- what remains
- exact blocker, if any
