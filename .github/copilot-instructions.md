# XPS Intelligence Control Plane — Copilot Instructions

You are working in the `xps-intelligence-control-plane` repository.

This repository is the master control plane, template factory, workflow factory, issue factory, and governance source for the XPS Intelligence ecosystem.

## Repository role
This repository is responsible for defining and governing:

- architecture
- system contracts
- repository map
- roadmap
- launch criteria
- issue taxonomy
- workflow taxonomy
- template manifests
- reusable GitHub workflows
- environment and credential contracts
- integration contracts
- ontology
- data schema authority
- seed registry authority
- prompt authority
- repo creation order
- issue ladder order

This repository is not the live runtime system.
It defines how the live runtime system must be built, deployed, validated, and evolved.

## Ecosystem authority
This repository governs and templates these repositories:

- `xps-intelligence-system`
- `xps-source-adapter-template`
- `xps-ui`
- `xps-google-workspace-bridge`
- `xps-analytics-bi`
- `xps-employee-copilots`

## Required reading before changes
Before changing anything:

1. Read the repo wiki Home page.
2. Read this file.
3. Inspect the current repository structure.
4. Read the authoritative architecture and contract docs already present.
5. Preserve repo authority and avoid drift.

## Non-negotiable rules
- No mock production contracts presented as final.
- No fake integration endpoints.
- No fabricated orchestrator routes.
- No TODO placeholders where a first-pass production contract can be written now.
- No undocumented production write behavior.
- GitHub is the source of truth for governance, docs, workflows, templates, and repo standards.
- This repo defines the law; downstream repos implement it.
- Be deterministic, explicit, and fail-loud.
- Prefer reusable templates and reusable workflows over duplicated patterns.
- Every template must include docs, env contracts, issue ladders, PR templates, and validation expectations.

## Primary objectives
Maintain and improve the control plane so it can:

- generate repeatable repo structures
- generate repeatable issue ladders
- generate repeatable workflow patterns
- generate repeatable environment contracts
- generate repeatable integration contracts
- generate repeatable launch checklists
- support issue -> PR -> CI -> deploy -> smoke -> evidence execution

## Must-have artifacts
When relevant, create or maintain:

- `docs/01-architecture/XPS_MASTER_BLUEPRINT.md`
- `docs/01-architecture/SYSTEM_CONTRACT.md`
- `docs/01-architecture/REPOSITORY_MAP.md`
- `docs/02-roadmap/MONDAY_MVP_ROADMAP.md`
- `docs/03-checklists/LAUNCH_CHECKLIST.md`
- `docs/04-issues/*`
- `docs/05-security/UNIFIED_CREDENTIAL_AND_ENVIRONMENT_STRATEGY.md`
- `docs/06-integrations/*`
- `docs/07-prompts/*`
- `schemas/raw/*`
- `schemas/normalized/*`
- `schemas/activation/*`
- `schemas/crm/*`
- `schemas/ontology/*`
- `seed/source-registry/*`
- `seed/categories/*`
- `templates/*`
- `.github/workflows/*`
- `.github/ISSUE_TEMPLATE/*`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/CODEOWNERS`

## Reusable workflow rules
Reusable workflows must be structured for downstream repo reuse.
Prefer reusable patterns for:

- CI
- Pages
- repo health
- template validation
- postdeploy smoke
- Railway deploy orchestration where appropriate

## Issue system rules
This repo must define issue ladders and issue forms for downstream repo bootstrapping.

Every issue pattern should include:
- objective
- required reading
- scope
- constraints
- deliverables
- acceptance criteria
- evidence required
- next issue after merge

## Environment contract rules
This repo is responsible for one canonical env naming system across:

- GitHub
- Railway
- Supabase
- HubSpot
- Google Workspace / Apps Script
- OpenAI / GPT actions
- Groq
- Ollama Cloud
- Bytebot where applicable

Do not allow secret naming drift.

## Working style
- define before implementing
- template before repeating
- validate before claiming complete
- document ownership clearly
- fail loudly on ambiguity
- keep downstream repos aligned

## Completion standard
Do not mark work complete unless you provide:
- changed files
- what contract/template/workflow was added or updated
- what downstream repos are affected
- what validation was performed
- blockers
- exact next step
