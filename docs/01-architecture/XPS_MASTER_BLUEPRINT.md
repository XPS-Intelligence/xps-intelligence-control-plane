# XPS Intelligence — Master Blueprint

> Version 1.0 | Status: Living Document

---

## 1. Mission

Build a **self-sustaining B2B intelligence engine** that continuously discovers, enriches, and activates high-intent company and contact signals — eliminating manual prospecting and keeping the CRM perpetually fresh.

---

## 2. System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    XPS Control Plane                        │
│                                                             │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌─────────┐ │
│  │  SOURCE  │──▶│   RAW    │──▶│NORMALIZED│──▶│ACTIVATED│ │
│  │ REGISTRY │   │ RECORDS  │   │ RECORDS  │   │  LEADS  │ │
│  └──────────┘   └──────────┘   └──────────┘   └─────────┘ │
│       │               │               │              │      │
│  Crawlers &      Supabase DB     Enrichment      HubSpot    │
│  Adapters        (raw layer)      Pipeline        CRM        │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Core Layers

### 3.1 Source Registry Layer

All data sources are registered in `seed/source-registry/source_registry.csv`. Each source has:

- A unique `source_id` slug
- A `crawler_type` (web / api / rss / manual)
- A `refresh_cadence` (nightly / weekly / manual)
- An `owner` (team member responsible)

New sources are added via the GitHub Issue template `.github/ISSUE_TEMPLATE/new-source.yml`.

### 3.2 Raw Ingestion Layer

Crawlers and adapters produce records conforming to `schemas/raw/raw_source_record.v1.json`. Key properties:

- `source_id` — links back to source registry
- `raw_payload` — unmodified JSON blob from the source
- `ingested_at` — ISO 8601 UTC timestamp
- `record_hash` — SHA-256 of raw payload for deduplication

Raw records land in the Supabase `raw_records` table and are **immutable** once written.

### 3.3 Normalization Layer

A normalization pipeline maps raw records → `schemas/normalized/company_record.v1.json`:

- Field extraction rules are defined per `source_id`
- Entity resolution deduplicates companies by domain + name similarity
- The output populates the `company_records` table in Supabase

### 3.4 Enrichment Layer

Nightly enrichment (`.github/workflows/nightly-enrich.yml`) augments normalized records:

- Firmographic data (employee count, revenue range, tech stack)
- Intent signals (job postings, funding events, product launches)
- Contact discovery (decision-maker name, email, LinkedIn URL)

Enrichment leverages AI classification via the prompts in `docs/07-prompts/`.

### 3.5 Activation Layer

Enriched records meeting activation criteria are pushed to HubSpot CRM as Companies and Contacts. The mapping is defined in `schemas/crm/hubspot_mapping.v1.json`. Lead activation records conform to `schemas/activation/lead_activation_record.v1.json`.

---

## 4. Infrastructure

| Concern | Technology |
|---------|-----------|
| Compute / Workers | Railway (containerized services) |
| Database | Supabase (PostgreSQL + Row-Level Security) |
| CRM | HubSpot (Companies + Contacts + Deals) |
| Automation glue | Google Apps Script (Sheets bridge) |
| CI/CD | GitHub Actions |
| Secrets | Railway environment variables |

See individual integration docs under `integrations/`.

---

## 5. Data Flow Sequence

```
1. Scheduler triggers crawler (cron / GitHub Actions)
2. Crawler fetches page / API response
3. Adapter transforms response → RawSourceRecord
4. RawSourceRecord upserted into Supabase raw_records
5. Normalization worker picks up new raw_records
6. Worker produces CompanyRecord → Supabase company_records
7. Nightly enrichment augments CompanyRecord fields
8. Activation scorer evaluates enriched records
9. High-score records pushed to HubSpot as Companies + Contacts
10. HubSpot triggers sequences / deal creation
```

---

## 6. Schema Versioning

- All schemas live under `schemas/` and are versioned (`v1`, `v2`, …)
- Breaking changes require a version bump and migration script
- Non-breaking additions (new optional fields) can be applied in-place with a changelog entry

---

## 7. Security Principles

- No secrets committed to source code
- All credentials stored in Railway environment variables or Supabase Vault
- Row-Level Security (RLS) enabled on all Supabase tables
- HubSpot API keys scoped to minimum required permissions
- All outbound HTTP requests rate-limited and retried with exponential back-off

---

## 8. Observability

- Each pipeline stage emits structured JSON logs to stdout
- Railway log drains forward to the configured log aggregator
- Failed records are written to a `dead_letter_queue` table for inspection
- Nightly enrichment posts a summary to the configured Slack channel

---

## 9. Glossary

| Term | Definition |
|------|-----------|
| Source | An external data origin (website, API, feed) |
| Adapter | Code that translates a source's format into RawSourceRecord |
| Entity Resolution | The process of identifying that two records refer to the same real-world company |
| Activation | Pushing a qualified lead into CRM for sales follow-up |
| Control Plane | This repository — governs all pipeline configuration and schemas |
