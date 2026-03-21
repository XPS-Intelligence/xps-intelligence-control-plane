# Copilot Instructions — XPS Intelligence Control Plane

> These instructions guide GitHub Copilot and AI coding assistants working in this repository.

---

## Project Overview

This repository is the **control plane** for the XPS Intelligence data pipeline. It contains:
- Schema definitions (JSON Schema draft-07)
- Seed data (CSV)
- GitHub Actions workflows
- Integration documentation
- AI prompt templates

The system ingests raw company data from multiple sources, normalizes it into canonical records, enriches it with AI, and activates qualified leads in HubSpot CRM.

---

## Architecture Principles

1. **Schemas first** — Any new data shape must be defined in `schemas/` before code is written
2. **Source registry** — All data sources must be registered in `seed/source-registry/source_registry.csv`
3. **Immutable raw records** — Raw source records are never modified after ingestion
4. **Versioned contracts** — Schema changes require version bumps per `docs/01-architecture/SYSTEM_CONTRACT.md`
5. **No secrets in code** — All credentials go in Railway environment variables

---

## Code Style and Conventions

### JSON Schemas
- Use `$schema: "http://json-schema.org/draft-07/schema#"`
- Always include `$id`, `title`, `description`, and `version` fields
- Reference shared types from `schemas/ontology/xps_ontology.v1.json`
- Use `additionalProperties: false` on all top-level objects
- Provide at least one `examples` entry per schema

### CSV Files
- Always include a header row
- Use snake_case for column names
- Use `true`/`false` for boolean values
- Escape commas with double-quotes where needed

### Markdown Documents
- Use ATX-style headings (`#`, `##`)
- Include a version and status line below the H1
- Use tables for structured reference data
- Use checkboxes (`- [ ]`) for actionable items

### GitHub Actions Workflows
- Pin action versions with full SHA or major version tag
- Use `secrets.` for all credentials — never hardcode values
- All workflows must have a `name` field and `on` trigger
- Include `permissions` blocks scoped to minimum required

---

## Domain Knowledge

### Key Terms
- **Source** — An external origin of company/contact data (website, API, feed)
- **Adapter** — The code that transforms a source's format into `RawSourceRecord`
- **Entity Resolution** — Detecting that two records refer to the same company
- **Enrichment** — Augmenting a normalized record with additional data or AI inference
- **Activation** — Pushing a qualified lead into HubSpot CRM

### Schema Hierarchy
```
RawSourceRecord → (normalization) → CompanyRecord → (enrichment) → LeadActivationRecord → HubSpot
```

### Supabase Tables
- `raw_records` — stores `RawSourceRecord` objects
- `company_records` — stores `CompanyRecord` objects
- `lead_activation_records` — stores `LeadActivationRecord` objects
- `dead_letter_queue` — stores failed records for inspection

---

## What to Avoid

- Do NOT commit secrets, API keys, or passwords
- Do NOT modify `schema_version` constants without bumping the version filename
- Do NOT remove required fields from schemas (breaking change)
- Do NOT hardcode HubSpot property names — use `schemas/crm/hubspot_mapping.v1.json`
- Do NOT bypass entity resolution — always check for existing `company_id` by domain

---

## Helpful References

- System architecture: `docs/01-architecture/XPS_MASTER_BLUEPRINT.md`
- Interface contracts: `docs/01-architecture/SYSTEM_CONTRACT.md`
- HubSpot object model: `integrations/hubspot/HUBSPOT_OBJECT_MODEL.md`
- Supabase setup: `integrations/supabase/SUPABASE_SETUP.md`
- Railway env vars: `integrations/railway/ENVIRONMENT_CONTRACT.md`
