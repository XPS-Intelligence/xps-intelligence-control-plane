# XPS Intelligence — Repository Map

**Version:** 1.0.0
**Status:** AUTHORITATIVE
**Owner:** XPS Intelligence Engineering

---

## Repository Ecosystem

| Repo | Role | Status | Depends On |
|------|------|--------|------------|
| xps-intelligence-control-plane | Governance, schemas, contracts, blueprints | ACTIVE | — |
| xps-intelligence-system | Core pipeline: ingest, normalize, enrich, score, activate | PLANNED | control-plane |
| xps-source-adapters | Source-specific data connectors | PLANNED | system |
| xps-workspace-bridge | Google Workspace / Apps Script integration | PLANNED | system |
| xps-analytics | Analytics, reporting, dashboards | PLANNED | system |
| xps-employee-copilots | Employee-facing AI copilot interfaces | PLANNED | system, workspace-bridge |

---

## Control Plane Repository Structure

```
xps-intelligence-control-plane/
├── README.md                          # Entry point, build order, platform stack
├── docs/
│   ├── 01-architecture/
│   │   ├── XPS_MASTER_BLUEPRINT.md    # Master system blueprint
│   │   ├── SYSTEM_CONTRACT.md         # Non-negotiable behavioral contracts
│   │   └── REPOSITORY_MAP.md          # This file
│   ├── 02-roadmap/
│   │   └── MONDAY_MVP_ROADMAP.md      # Monday MVP milestones and sprint plan
│   ├── 03-checklists/
│   │   └── LAUNCH_CHECKLIST.md        # Gate-by-gate launch readiness checklist
│   ├── 04-runbooks/
│   │   └── (operational runbooks)
│   ├── 05-security/
│   │   └── UNIFIED_CREDENTIAL_AND_ENVIRONMENT_STRATEGY.md
│   ├── 06-integrations/
│   │   └── INTEGRATION_MATRIX.md      # Cross-platform integration matrix
│   └── 07-prompts/
│       ├── MASTER_INVOCATION_PROMPT.md
│       └── COPILOT_BUILD_PROTOCOL.md
├── schemas/
│   ├── raw/
│   │   └── raw_source_record.v1.json
│   ├── normalized/
│   │   ├── company_record.v1.json
│   │   └── contact_record.v1.json
│   ├── activation/
│   │   └── lead_activation_record.v1.json
│   ├── crm/
│   │   └── hubspot_mapping.v1.json
│   └── ontology/
│       └── xps_ontology.v1.json
├── seed/
│   ├── source-registry/
│   │   └── source_registry.csv
│   └── categories/
│       └── industry_taxonomy.csv
├── templates/
│   ├── repo-template/
│   │   └── REPO_TEMPLATE_MANIFEST.md
│   ├── service-template/
│   │   └── SERVICE_TEMPLATE_MANIFEST.md
│   └── workflow-template/
│       └── WORKFLOW_TEMPLATE_MANIFEST.md
├── integrations/
│   ├── github/
│   │   ├── GITHUB_PROJECT_AND_AUTOMATION_SPEC.md
│   │   └── XPS_ORCHESTRATOR_INTEGRATION_SPEC.md
│   ├── railway/
│   │   └── ENVIRONMENT_CONTRACT.md
│   ├── supabase/
│   │   └── SUPABASE_DATA_AND_VECTOR_SPEC.md
│   ├── hubspot/
│   │   └── HUBSPOT_OBJECT_MODEL.md
│   ├── google/
│   │   └── GOOGLE_WORKSPACE_BRIDGE_SPEC.md
│   └── openai/
│       └── OPENAI_GPT_ACTIONS_SCHEMA.md
├── site/                              # GitHub Pages static site
│   ├── index.html
│   └── assets/
└── .github/
    ├── copilot-instructions.md
    ├── PULL_REQUEST_TEMPLATE.md
    ├── ISSUE_TEMPLATE/
    │   ├── new-source.yml
    │   ├── bug.yml
    │   ├── architecture-change.yml
    │   └── integration-request.yml
    └── workflows/
        ├── ci.yml
        ├── pages.yml
        ├── repo-health.yml
        └── template-validation.yml
```

---

## Downstream Repo Templates

Each downstream repo will be bootstrapped from templates in `/templates/`. See:
- `templates/repo-template/REPO_TEMPLATE_MANIFEST.md` — Required files for any new XPS repo.
- `templates/service-template/SERVICE_TEMPLATE_MANIFEST.md` — Service scaffold requirements.
- `templates/workflow-template/WORKFLOW_TEMPLATE_MANIFEST.md` — Reusable CI/CD patterns.
