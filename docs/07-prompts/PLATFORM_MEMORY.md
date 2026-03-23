# XPS Platform Memory

## Purpose
This file is the durable rehydration source for the XPS Intelligence ecosystem.
It captures the platform truth that should survive across chats, sessions, and contributors.

## Canonical ecosystem
- `xps-intelligence-control-plane` = governance and template authority
- `xps-intelligence-system` = runtime host
- `xps-intel` = intelligence authority
- `xps-distallation-system` = distillation authority
- `xps-ui` = shared UI and editor foundation
- `xps-source-adapter-template` = governed scanner/adapter starter
- `xps-google-workspace-bridge` = workspace integration layer
- `xps-analytics-bi` = KPI, forecasting, simulation, benchmarking
- `xps-employee-copilots` = role assistants, skills, prompts, persona packs
- `agent system` = bounded parallel lanes, validation, reflection, failover, and documentation discipline

## Donor systems
- `xps-intelligence-system-v.5` = strongest donor for current portal runtime and appearance
- `xps-intelligence-systems` = environment and integration donor
- `XPS_INTELLIGENCE_SYSTEM` = large donor with chat/control/scraper concepts
- `open-lovable` = editor and app-builder donor

## Default platform law
- GitHub is the source of truth.
- Railway is the default runtime platform.
- Docker is the default local integration and validation environment.
- Postgres is the canonical relational store.
- Redis is the canonical async execution layer.
- Next.js is the preferred host frontend.
- Open source and proven templates should be preferred over novelty stacks.

## Runtime target
The internal platform must support:
- employee workspace
- manager workspace
- owner workspace
- admin control plane
- lead ingestion, validation, scoring, and recommendation
- proactive assistants with memory, skills, and autonomy modes
- editable frontend and builder/editor capabilities
- governed scraper/crawler orchestration

## Canonical data flow
1. source registry
2. seed registry
3. crawl/search job
4. crawl run
5. raw observation
6. parsed observation
7. entity resolution
8. canonical entity
9. validation/enrichment
10. lead candidate
11. score
12. recommendation
13. CRM activation

## Active build order
1. control plane memory and contract layer
2. intelligence and distillation bootstrap
3. runtime host stabilization
4. role workspaces and assistant framework
5. admin control plane and editor
6. CI/CD, postdeploy smoke, and self-healing operations
7. bounded parallel agent system, prompt library, and failover runbooks

## Invocation anchors
- primary invocation source: `docs/07-prompts/MASTER_INVOCATION_PROMPT.md`
- primary revealer source: `docs/07-prompts/MASTER_REVEALER_PROMPT.md`
- overnight continuity source: `docs/07-prompts/OVERNIGHT_CONTINUITY_PROMPT.md`
- agent system entry: `docs/01-architecture/AGENT_SYSTEM_README.md`
- overnight continuity package: `docs/01-architecture/OVERNIGHT_CONTINUITY_PACKAGE.md`
- agent prompt library: `docs/07-prompts/AGENT_PROMPT_LIBRARY.md`
- validation gate: `docs/03-checklists/AGENT_VALIDATION_GATE.md`
- failover runbook: `docs/04-issues/AGENT_OPERATION_RUNBOOK.md`
- overnight continuity runbook: `docs/04-issues/OVERNIGHT_CONTINUITY_RUNBOOK.md`
- architecture authority: `docs/01-architecture/ENTERPRISE_AUTONOMY_BLUEPRINT.md`
- full stack authority: `docs/01-architecture/FULL_STACK_SPEC.md`
- phase authority: `docs/02-roadmap/FULL_PHASE_ROADMAP.md`
- benchmark authority: `docs/03-checklists/ENTERPRISE_BENCHMARK_MATRIX.md`

## Immediate runtime focus
- Railway-first auth
- role pages
- admin/editor donor integration
- `xps-intel` retrieval wiring
- `xps-distallation-system` runtime wiring
- benchmark and e2e validation for lead ingestion and intelligence paths
- agent validation gate, reflection loop, and backup-failover lane
- overnight continuity package for bounded unattended execution and morning handoff
