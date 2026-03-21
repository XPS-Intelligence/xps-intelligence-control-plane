# XPS Intelligence — System Contract

> Version 1.0 | This document defines the authoritative interfaces between all system components. Any change to these contracts requires a PR with an updated version number and migration notes.

---

## 1. Overview

This contract governs:

1. **Data schemas** — the canonical shape of records at each pipeline stage
2. **API interfaces** — how services communicate with each other
3. **Event contracts** — what events are emitted and consumed
4. **Environment variables** — what each service requires to run
5. **SLA expectations** — latency and availability guarantees per stage

---

## 2. Schema Contracts

### 2.1 Raw Source Record

**Schema file:** `schemas/raw/raw_source_record.v1.json`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | ✅ | Schema version identifier, e.g. `"raw/v1"` |
| `record_id` | string (uuid) | ✅ | Unique record ID (UUIDv4) |
| `source_id` | string | ✅ | References `source_id` in source registry |
| `ingested_at` | string (ISO 8601) | ✅ | UTC timestamp of ingestion |
| `record_hash` | string | ✅ | SHA-256 hex digest of `raw_payload` |
| `raw_payload` | object | ✅ | Unmodified source data blob |
| `crawler_version` | string | ❌ | Semver of the crawler that produced this record |
| `tags` | array[string] | ❌ | Free-form classification tags |

**Deduplication rule:** Records with an identical `source_id` + `record_hash` combination are idempotently upserted (no duplicate rows).

### 2.2 Normalized Company Record

**Schema file:** `schemas/normalized/company_record.v1.json`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | ✅ | `"normalized/v1"` |
| `company_id` | string (uuid) | ✅ | Stable internal company ID |
| `name` | string | ✅ | Legal or trading name |
| `domain` | string | ✅ | Primary web domain (no protocol) |
| `industry` | string | ❌ | Taxonomy value from `seed/categories/industry_taxonomy.csv` |
| `employee_range` | string | ❌ | Enum: `1-10 | 11-50 | 51-200 | 201-500 | 501-1000 | 1001+` |
| `hq_country` | string | ❌ | ISO 3166-1 alpha-2 country code |
| `hq_city` | string | ❌ | City name |
| `description` | string | ❌ | Short company description |
| `linkedin_url` | string (uri) | ❌ | LinkedIn company page URL |
| `source_ids` | array[string] | ✅ | All source IDs that contributed to this record |
| `created_at` | string (ISO 8601) | ✅ | First seen timestamp |
| `updated_at` | string (ISO 8601) | ✅ | Last enriched timestamp |
| `enrichment_score` | number [0-100] | ❌ | Data completeness score |

### 2.3 Lead Activation Record

**Schema file:** `schemas/activation/lead_activation_record.v1.json`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | ✅ | `"activation/v1"` |
| `activation_id` | string (uuid) | ✅ | Unique activation event ID |
| `company_id` | string (uuid) | ✅ | References normalized company record |
| `contact_name` | string | ❌ | Decision-maker full name |
| `contact_email` | string (email) | ❌ | Decision-maker email |
| `contact_title` | string | ❌ | Job title |
| `intent_signals` | array[string] | ❌ | Detected intent events |
| `activation_score` | number [0-100] | ✅ | Overall lead quality score |
| `hubspot_company_id` | string | ❌ | HubSpot Company object ID (set after push) |
| `hubspot_contact_id` | string | ❌ | HubSpot Contact object ID (set after push) |
| `activated_at` | string (ISO 8601) | ✅ | Timestamp of activation push |
| `status` | string | ✅ | Enum: `pending | pushed | failed | suppressed` |

---

## 3. API Interface Contracts

### 3.1 Normalization Worker

**Protocol:** Internal function call / queue worker  
**Input:** `RawSourceRecord` (from Supabase `raw_records` table)  
**Output:** Upserted `CompanyRecord` in Supabase `company_records` table  
**Error handling:** Failed records written to `dead_letter_queue` with `error_code` and `error_message`

### 3.2 Enrichment Service

**Protocol:** REST HTTP (Railway service)  
**Endpoint:** `POST /enrich`  
**Input body:**
```json
{
  "company_id": "<uuid>",
  "fields_to_enrich": ["employee_range", "description", "linkedin_url"]
}
```
**Response:**
```json
{
  "company_id": "<uuid>",
  "enriched_fields": { "employee_range": "51-200", "description": "..." },
  "enrichment_score": 82,
  "enriched_at": "2025-01-01T00:00:00Z"
}
```

### 3.3 HubSpot Activation Service

**Protocol:** REST HTTP (Railway service)  
**Endpoint:** `POST /activate`  
**Input body:** `LeadActivationRecord` (without `hubspot_*` IDs)  
**Response:**
```json
{
  "activation_id": "<uuid>",
  "hubspot_company_id": "12345678",
  "hubspot_contact_id": "87654321",
  "status": "pushed"
}
```

---

## 4. Event Contracts

| Event | Producer | Consumer | Payload |
|-------|---------|---------|---------|
| `raw_record.created` | Crawler | Normalization Worker | `{ record_id, source_id }` |
| `company_record.updated` | Normalization Worker | Enrichment Service | `{ company_id }` |
| `company_record.enriched` | Enrichment Service | Activation Scorer | `{ company_id, enrichment_score }` |
| `lead.activated` | Activation Service | HubSpot, Slack | `{ activation_id, company_id, status }` |
| `lead.failed` | Activation Service | Dead Letter Queue | `{ activation_id, error_code, error_message }` |

---

## 5. Environment Variable Contract

See `integrations/railway/ENVIRONMENT_CONTRACT.md` for the full list of required environment variables per service.

**Summary of critical variables:**

| Variable | Service | Description |
|----------|---------|-------------|
| `SUPABASE_URL` | All | Supabase project URL |
| `SUPABASE_SERVICE_ROLE_KEY` | Workers | Supabase service role key (privileged) |
| `HUBSPOT_API_KEY` | Activation | HubSpot private app token |
| `OPENAI_API_KEY` | Enrichment | OpenAI API key for AI enrichment |
| `RAILWAY_ENVIRONMENT` | All | `production` or `staging` |

---

## 6. SLA Expectations

| Stage | Target Latency | Target Availability |
|-------|---------------|-------------------|
| Raw ingestion (per record) | < 2 s | 99.5% |
| Normalization (per record) | < 5 s | 99% |
| Nightly enrichment (full run) | < 4 hours | 95% |
| HubSpot activation (per lead) | < 10 s | 99% |

---

## 7. Breaking vs Non-Breaking Changes

### Non-breaking (allowed without version bump):
- Adding a new **optional** field to any schema
- Adding a new **optional** query parameter to an API
- Adding a new event type

### Breaking (requires version bump + migration):
- Renaming or removing any existing field
- Changing a field's type
- Making an optional field required
- Changing an API endpoint path or HTTP method
