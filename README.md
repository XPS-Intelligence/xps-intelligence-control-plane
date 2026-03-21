# XPS Intelligence Control Plane

> **Reusable adapter starter for any new data source — collect, normalize, enrich, and activate company and lead intelligence at scale.**

---

## Overview

The XPS Intelligence Control Plane is the central orchestration layer for the XPS Intelligence data platform. It governs:

- **Ingestion** – crawling and collecting raw records from registered data sources
- **Normalization** – transforming raw records into a canonical company/contact schema
- **Enrichment** – augmenting normalized records with third-party signals and AI inference
- **Activation** – pushing enriched leads into CRM (HubSpot) and downstream workflows

---

## Repository Structure

```
xps-intelligence-control-plane/
├── docs/
│   ├── 01-architecture/        # System blueprint and contracts
│   ├── 02-roadmap/             # MVP and sprint roadmaps
│   ├── 03-checklists/          # Launch and QA checklists
│   └── 07-prompts/             # AI prompt templates
├── schemas/
│   ├── ontology/               # Shared ontology / vocabulary
│   ├── raw/                    # Inbound raw source record schema
│   ├── normalized/             # Canonical company record schema
│   ├── crm/                    # HubSpot field-mapping schema
│   └── activation/             # Lead activation payload schema
├── seed/
│   ├── source-registry/        # CSV registry of all active sources
│   └── categories/             # Industry taxonomy seed data
├── integrations/
│   ├── railway/                # Railway deployment environment contract
│   ├── supabase/               # Supabase project setup guide
│   ├── hubspot/                # HubSpot object model reference
│   └── google/                 # Google Apps Script bridge docs
└── .github/
    ├── workflows/              # CI/CD, nightly enrichment, smoke tests
    ├── ISSUE_TEMPLATE/         # GitHub Issue templates
    ├── PULL_REQUEST_TEMPLATE.md
    └── copilot-instructions.md
```

---

## Quick Start

### Prerequisites

| Tool | Version |
|------|---------|
| Node.js | ≥ 18 LTS |
| Python | ≥ 3.11 |
| Railway CLI | latest |
| Supabase CLI | latest |

### 1. Clone and install dependencies

```bash
git clone https://github.com/XPS-Intelligence/xps-intelligence-control-plane.git
cd xps-intelligence-control-plane
npm install        # or: pip install -r requirements.txt
```

### 2. Configure environment

Copy the environment contract and fill in secrets:

```bash
cp integrations/railway/ENVIRONMENT_CONTRACT.md .env.example
# then set real values in Railway dashboard or local .env
```

### 3. Run CI locally

```bash
npm test           # unit tests
npm run lint       # linting
```

---

## Key Documentation

| Document | Purpose |
|----------|---------|
| [Master Blueprint](docs/01-architecture/XPS_MASTER_BLUEPRINT.md) | End-to-end architecture |
| [System Contract](docs/01-architecture/SYSTEM_CONTRACT.md) | Interface & data contracts |
| [Monday MVP Roadmap](docs/02-roadmap/MONDAY_MVP_ROADMAP.md) | Sprint-zero deliverables |
| [Launch Checklist](docs/03-checklists/LAUNCH_CHECKLIST.md) | Go-live gate criteria |
| [HubSpot Object Model](integrations/hubspot/HUBSPOT_OBJECT_MODEL.md) | CRM field definitions |
| [Supabase Setup](integrations/supabase/SUPABASE_SETUP.md) | Database provisioning |
| [Railway Environment Contract](integrations/railway/ENVIRONMENT_CONTRACT.md) | Env-var reference |

---

## Schemas

All schemas follow JSON Schema draft-07 and are versioned with a `v1` suffix.

| Schema | Path |
|--------|------|
| XPS Ontology | `schemas/ontology/xps_ontology.v1.json` |
| Raw Source Record | `schemas/raw/raw_source_record.v1.json` |
| Normalized Company Record | `schemas/normalized/company_record.v1.json` |
| HubSpot CRM Mapping | `schemas/crm/hubspot_mapping.v1.json` |
| Lead Activation Record | `schemas/activation/lead_activation_record.v1.json` |

---

## Contributing

1. Open an issue using the appropriate template (`.github/ISSUE_TEMPLATE/`)
2. Branch off `main` following the convention `feat/<short-description>`
3. Submit a PR using the provided template
4. All CI checks must pass before merge

See [COPILOT_BUILD_PROMPT](docs/07-prompts/COPILOT_BUILD_PROMPT.md) for AI-assisted development guidelines.

---

## License

Proprietary — XPS Intelligence. All rights reserved.
