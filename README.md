# XPS Intelligence Control Plane

**Repository Role:** Official source of truth for system architecture, blueprint, schemas, ontology, integration contracts, automation templates, and repo governance for the XPS Vertical Intelligence and Revenue OS.

> **LAW:** The files in this repository are the authoritative system definition. The wiki is supplementary documentation only. Never treat the wiki as executable truth.

---

## Strict Build Order

The following order is non-negotiable. No downstream repo may be bootstrapped before its upstream dependency is production-ready.

| Order | Repository | Role |
|-------|-----------|------|
| 1 | **xps-intelligence-control-plane** (this repo) | Governance, blueprints, schemas, contracts |
| 2 | xps-intelligence-system | Core implementation: pipelines, enrichment, scoring |
| 3 | xps-source-adapters | Source-specific data connectors |
| 4 | xps-workspace-bridge | Google Workspace / Apps Script bridge |
| 5 | xps-analytics | Analytics, BI, and reporting layer |
| 6 | xps-employee-copilots | Employee-facing AI copilot interfaces |

---

## Repository Map

```
xps-intelligence-control-plane/
├── docs/
│   ├── 01-architecture/     # System blueprints, contracts, repository map
│   ├── 02-roadmap/          # Monday MVP roadmap and milestones
│   ├── 03-checklists/       # Launch checklists
│   ├── 04-runbooks/         # Operational runbooks
│   ├── 05-security/         # Credential strategy and security policies
│   ├── 06-integrations/     # Integration matrix
│   └── 07-prompts/          # Master invocation prompts and Copilot build protocol
├── schemas/
│   ├── raw/                 # Inbound source record schemas
│   ├── normalized/          # Canonical normalized record schemas
│   ├── activation/          # Lead activation record schemas
│   ├── crm/                 # HubSpot CRM mapping schemas
│   └── ontology/            # XPS domain ontology
├── seed/
│   ├── source-registry/     # Registry of all ingestion sources
│   └── categories/          # Industry and category taxonomy
├── templates/
│   ├── repo-template/       # Template manifests for new repos
│   ├── service-template/    # Service scaffold templates
│   └── workflow-template/   # Reusable workflow templates
├── integrations/
│   ├── github/              # GitHub project and automation specs
│   ├── railway/             # Railway environment contract
│   ├── supabase/            # Supabase data and vector spec
│   ├── hubspot/             # HubSpot object model
│   ├── google/              # Google Workspace bridge spec
│   └── openai/              # OpenAI GPT action schema
├── site/                    # GitHub Pages static site
└── .github/
    ├── workflows/           # CI, Pages, repo-health, template-validation
    ├── ISSUE_TEMPLATE/      # Standardized issue templates
    ├── PULL_REQUEST_TEMPLATE.md
    └── copilot-instructions.md
```

---

## Platform Stack

| Plane | Platform | Role |
|-------|----------|------|
| Governance / Control | GitHub | Source of truth, automation, versioning |
| Runtime | Railway | Service deployment and environment management |
| Intelligence / Data | Supabase / Postgres | Data persistence, vector embeddings, intelligence layer |
| CRM / Action | HubSpot | Lead management, contact records, deal pipeline |
| Reasoning / Orchestration | OpenAI / GPT | AI reasoning, enrichment orchestration |
| Workspace | Google Workspace | Sheets, Drive, Apps Script bridge |
| Voice | ElevenLabs | Voice synthesis and notifications |
| LLM (fast) | Groq | High-throughput inference |
| LLM (local) | Ollama | Local/offline inference |

---

## No-Mock-Data Policy

This repository enforces a strict no-mock-data policy across all downstream systems:

- **Development must target real schemas.** Schema files in `/schemas/` are the canonical contract.
- **Sample values are illustrative only.** Any example data in docs or schemas is for illustration purposes and must be clearly marked `# EXAMPLE` or `// EXAMPLE`.
- **No fake seeded CRM production records.** Do not write fabricated HubSpot records to production.
- **Demo data must be clearly marked non-production.** Any data file containing demo or test records must include a `_demo` or `_test` suffix and a header comment.
- **Stub services are not complete services.** A stub must be marked `STATUS: STUB` and must not be connected to live production endpoints.

---

## Key Documents

- [Master Blueprint](docs/01-architecture/XPS_MASTER_BLUEPRINT.md)
- [System Contract](docs/01-architecture/SYSTEM_CONTRACT.md)
- [Repository Map](docs/01-architecture/REPOSITORY_MAP.md)
- [Monday MVP Roadmap](docs/02-roadmap/MONDAY_MVP_ROADMAP.md)
- [Launch Checklist](docs/03-checklists/LAUNCH_CHECKLIST.md)
- [Credential & Environment Strategy](docs/05-security/UNIFIED_CREDENTIAL_AND_ENVIRONMENT_STRATEGY.md)
- [Integration Matrix](docs/06-integrations/INTEGRATION_MATRIX.md)
- [Copilot Build Protocol](docs/07-prompts/COPILOT_BUILD_PROTOCOL.md)

---

## CI Status

CI validates: markdown links · JSON syntax · YAML syntax · required files · folder structure
