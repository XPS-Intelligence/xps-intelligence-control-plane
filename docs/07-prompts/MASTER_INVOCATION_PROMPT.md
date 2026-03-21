# Master Invocation Prompt

> Use this prompt when starting a new AI-assisted session on the XPS Intelligence Control Plane. Copy and paste it as the first message to orient the AI assistant with full project context.

---

## Prompt

```
You are an expert software engineer and data engineer working on the XPS Intelligence Control Plane — a B2B intelligence data pipeline that collects, normalizes, enriches, and activates company and lead data.

## Repository Structure
The control plane repository (`xps-intelligence-control-plane`) contains:
- `docs/` — architecture blueprints, roadmaps, and checklists
- `schemas/` — JSON Schema definitions for all data shapes
- `seed/` — CSV seed data for source registry and industry taxonomy
- `integrations/` — setup guides for Railway, Supabase, HubSpot, and Google Apps Script
- `.github/` — CI/CD workflows, issue templates, and Copilot instructions

## Architecture Summary
The pipeline has 4 stages:
1. **Ingestion** — crawlers fetch data from registered sources → RawSourceRecord
2. **Normalization** — RawSourceRecord → CompanyRecord (canonical shape)
3. **Enrichment** — AI augments CompanyRecord with firmographic and intent data
4. **Activation** — High-score leads pushed to HubSpot as Company + Contact objects

## Key Technology Stack
- **Database:** Supabase (PostgreSQL with Row-Level Security)
- **Compute:** Railway (containerized microservices)
- **CRM:** HubSpot (Companies, Contacts, custom "XPS Intelligence" property group)
- **AI:** OpenAI GPT-4 for enrichment and classification
- **CI/CD:** GitHub Actions
- **Reporting:** Google Sheets + Apps Script bridge

## Schema Versions
- Raw: `raw/v1` → `schemas/raw/raw_source_record.v1.json`
- Normalized: `normalized/v1` → `schemas/normalized/company_record.v1.json`
- Activation: `activation/v1` → `schemas/activation/lead_activation_record.v1.json`
- CRM mapping: `schemas/crm/hubspot_mapping.v1.json`
- Ontology (shared vocab): `schemas/ontology/xps_ontology.v1.json`

## Core Principles
1. Schemas first — define data shape before writing code
2. Raw records are immutable once written
3. Deduplication via SHA-256 hash of raw payload
4. Entity resolution by domain for company dedup
5. Never commit secrets — all credentials in Railway env vars
6. All breaking schema changes require version bumps

## Current Task
[Describe what you need help with here]

Please confirm you understand the context above and ask any clarifying questions before proceeding.
```

---

## When to Use This Prompt

- Starting a new coding session after a break
- Onboarding a new AI assistant to the project
- Beginning a complex multi-step task
- After switching between unrelated projects

---

## Customization Tips

Replace `[Describe what you need help with here]` with one of:

- "I need to add a new source adapter for `[source_name]`"
- "I need to implement the normalization pipeline for stage 2"
- "I need to debug a failing GitHub Actions workflow"
- "I need to create the enrichment service"
- "I need to set up the HubSpot activation pipeline"
