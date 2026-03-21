# XPS Intelligence — Master Blueprint

**Version:** 1.0.0
**Status:** AUTHORITATIVE
**Owner:** XPS Intelligence Engineering

---

## 1. System Purpose

XPS Vertical Intelligence and Revenue OS is a B2B revenue intelligence platform that:

1. Ingests raw company and contact data from multiple source adapters.
2. Normalizes, enriches, and scores records against domain ontology.
3. Activates qualified leads into HubSpot for sales engagement.
4. Surfaces intelligence through GPT-powered copilots and workspace bridges.
5. Measures pipeline and conversion performance through analytics.

---

## 2. System Architecture

### 2.1 Data Flow

```
Source Adapters
    │
    ▼
Raw Ingest Layer (Supabase: raw_records table)
    │
    ▼
Normalization Pipeline (xps-intelligence-system)
    │
    ▼
Enrichment Engine (OpenAI / Groq / Ollama)
    │
    ▼
Scoring Engine (domain ontology + rules engine)
    │
    ▼
Activation Gate (threshold scoring → lead_activation_records)
    │
    ▼
HubSpot CRM Sync (contact + company + deal creation)
    │
    ▼
Analytics Layer (Supabase views + BI dashboards)
```

### 2.2 Platform Responsibilities

| Platform | Responsibility | Data Stored |
|----------|---------------|-------------|
| Supabase | Primary data store, vector search | All record types, embeddings, pipeline state |
| Railway | Service runtime | No persistent data; environment variables only |
| HubSpot | CRM record management | Contacts, Companies, Deals, Engagements |
| GitHub | Source of truth for code, schemas, contracts | N/A (no runtime data) |
| OpenAI | Reasoning and enrichment API | No persistent data |
| Google Workspace | Workspace integration, report delivery | Sheets, Drive files |

---

## 3. Core Data Entities

### 3.1 Raw Source Record
- Schema: `schemas/raw/raw_source_record.v1.json`
- Table: `supabase: raw_records`
- Lifecycle: RECEIVED → PARSED → NORMALIZED → DISCARDED

### 3.2 Normalized Company Record
- Schema: `schemas/normalized/company_record.v1.json`
- Table: `supabase: normalized_companies`
- Lifecycle: ACTIVE → ENRICHED → SCORED → ACTIVATED → SUPPRESSED

### 3.3 Normalized Contact Record
- Schema: `schemas/normalized/contact_record.v1.json`
- Table: `supabase: normalized_contacts`
- Lifecycle: ACTIVE → ENRICHED → SCORED → ACTIVATED → SUPPRESSED

### 3.4 Lead Activation Record
- Schema: `schemas/activation/lead_activation_record.v1.json`
- Table: `supabase: lead_activations`
- Lifecycle: PENDING → SYNCING → SYNCED → FAILED → SUPPRESSED

### 3.5 HubSpot CRM Mapping
- Schema: `schemas/crm/hubspot_mapping.v1.json`
- Maps normalized fields to HubSpot property names

---

## 4. Scoring Model

Lead scoring is deterministic and auditable. Scores are computed from:

| Signal | Weight | Source |
|--------|--------|--------|
| Industry match (ontology) | 25% | XPS ontology taxonomy |
| Company size fit | 20% | normalized_companies.employee_count |
| Technology stack alignment | 20% | Enrichment engine |
| Contact title/role match | 20% | normalized_contacts.title_normalized |
| Source quality score | 15% | seed/source-registry signal |

Minimum activation threshold: **Score ≥ 70**

---

## 5. Enrichment Engine

Enrichment is performed by the xps-intelligence-system service. It calls:

1. **OpenAI (primary):** Company description, industry classification, tech stack inference.
2. **Groq (fallback):** High-throughput batch enrichment.
3. **Ollama (local/offline):** Development and air-gapped enrichment.

All enrichment calls are logged with model version, timestamp, prompt hash, and output hash for auditability.

---

## 6. Activation Gate

A record is eligible for activation when:

- `score >= 70`
- `company.domain` is not null and not in suppression list
- `contact.email` is valid and not bounced
- `company.hubspot_id` is null (not already in CRM)
- Source record age < 180 days

---

## 7. Repo Build Order

The following order is non-negotiable:

1. `xps-intelligence-control-plane` — This repo. Governance, contracts, schemas.
2. `xps-intelligence-system` — Core pipeline, enrichment, scoring, activation.
3. `xps-source-adapters` — Source-specific connectors and parsers.
4. `xps-workspace-bridge` — Google Workspace / Apps Script integration.
5. `xps-analytics` — Analytics, reporting, BI.
6. `xps-employee-copilots` — Employee-facing AI copilots.

---

## 8. Governance Rules

- Schema changes require a PR with `schema-change` label and architectural review.
- Integration contract changes require both owner teams to approve.
- No production environment variable changes without documented change record.
- All pipeline state changes must be logged to `pipeline_events` table.
- All HubSpot writes must be logged to `hubspot_sync_log` table before execution.
- No direct database writes from GPT actions — all writes go through validated service endpoints.
