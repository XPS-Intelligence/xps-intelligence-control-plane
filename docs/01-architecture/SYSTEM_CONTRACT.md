# XPS Intelligence — System Contract

**Version:** 1.0.0
**Status:** AUTHORITATIVE
**Owner:** XPS Intelligence Engineering

This document defines the non-negotiable behavioral contracts between all system components. Any component that violates these contracts is considered broken and must not be deployed to production.

---

## 1. Data Contract

### 1.1 Raw Ingest Contract

- Every raw record arriving at the ingest layer MUST have a `source_id` referencing a registered source in `seed/source-registry/source_registry.csv`.
- Every raw record MUST have an `ingested_at` ISO 8601 timestamp.
- Every raw record MUST have a `raw_payload` stored as JSONB.
- Duplicate detection MUST be based on `source_id + source_record_id` composite key.
- Failed records MUST be written to `raw_records_failed` with `failure_reason` populated.

### 1.2 Normalization Contract

- The normalization pipeline MUST produce a record that fully conforms to `schemas/normalized/company_record.v1.json` or `schemas/normalized/contact_record.v1.json`.
- Records that fail normalization MUST be flagged `status: DISCARDED` with `discard_reason` populated.
- Normalized records MUST include `source_id`, `raw_record_id`, and `normalized_at` timestamp.

### 1.3 Enrichment Contract

- Enrichment services MUST log: `model_name`, `model_version`, `prompt_hash`, `response_hash`, `enriched_at`, `latency_ms`.
- Enrichment MUST be idempotent: re-running enrichment on the same record with the same model version MUST produce a deterministic result or log a discrepancy.
- Enrichment failures MUST NOT block downstream pipeline stages. Failed enrichment sets `enrichment_status: FAILED` and the record proceeds with available data.

### 1.4 Scoring Contract

- Scores MUST be computed deterministically from the scoring model defined in XPS_MASTER_BLUEPRINT.md Section 4.
- Score computation MUST log the individual signal values used.
- Score changes MUST be logged to `score_history` with `scored_at`, `previous_score`, `new_score`, `scored_by` (model/rule version).

### 1.5 Activation Contract

- No record may be written to HubSpot without passing ALL activation gate criteria defined in XPS_MASTER_BLUEPRINT.md Section 6.
- Every HubSpot write MUST be preceded by an entry in `hubspot_sync_log` with status `PENDING`.
- On successful sync, `hubspot_sync_log` MUST be updated to `SYNCED` with `hubspot_id`, `synced_at`.
- On failure, `hubspot_sync_log` MUST be updated to `FAILED` with `failure_reason` and `failed_at`.
- Activation is idempotent: a record with an existing `hubspot_id` MUST NOT be re-created.

---

## 2. API Contract

### 2.1 Internal Service APIs

- All internal service endpoints MUST accept and return JSON.
- All internal service endpoints MUST validate the request body against a defined schema before processing.
- All internal service endpoints MUST return HTTP 422 with a structured error body for validation failures.
- All internal service endpoints MUST be protected by service-to-service authentication (API key or JWT).
- All internal service endpoints MUST return a `request_id` in the response for traceability.

### 2.2 GPT Action Endpoints

- GPT action endpoints MUST be read-only by default.
- Write actions MUST require an explicit `confirm: true` parameter and a `justification` string.
- Write actions MUST log to `gpt_action_log` before executing.
- GPT actions MUST NOT have access to raw credentials. All actions MUST go through purpose-built service endpoints.
- See `integrations/openai/OPENAI_GPT_ACTIONS_SCHEMA.md` for full spec.

---

## 3. Environment Contract

- All environment variables MUST follow the naming convention defined in `docs/05-security/UNIFIED_CREDENTIAL_AND_ENVIRONMENT_STRATEGY.md`.
- No hardcoded credentials anywhere in any repository.
- No environment variable may be committed to git without being a non-secret placeholder.
- Railway environment variables are the runtime source of truth for deployed services.
- GitHub Secrets are the source of truth for CI/CD pipeline variables.
- Supabase service role key MUST only be used in server-side services, never in client-side code.

---

## 4. Schema Versioning Contract

- Schema files are versioned with `vN` suffix: `record_name.v1.json`, `record_name.v2.json`.
- Breaking changes MUST increment the major version.
- Non-breaking additions MAY use the same major version with a minor version in the schema `version` field.
- Deprecated schema versions MUST remain in the repository until all consumers have migrated.
- A schema change PR MUST include a migration plan for all existing records.

---

## 5. Audit and Observability Contract

- All pipeline state transitions MUST be logged to `pipeline_events`.
- All external API calls MUST be logged with: `service`, `endpoint`, `method`, `status_code`, `latency_ms`, `called_at`.
- All HubSpot writes MUST be logged (pre and post).
- All scoring operations MUST be logged with signal values.
- Log retention: minimum 90 days in Supabase, minimum 30 days in Railway log drain.
- Fail loud: errors MUST surface in logs with sufficient context to diagnose without additional investigation. Silent failures are contract violations.

---

## 6. Security Contract

- All secrets MUST be rotated on the schedule defined in `docs/05-security/UNIFIED_CREDENTIAL_AND_ENVIRONMENT_STRATEGY.md`.
- Supabase RLS (Row Level Security) MUST be enabled on all tables containing customer data.
- No service may access another service's Supabase tables directly — all cross-service data access goes through defined API endpoints.
- All Railway services MUST run with the minimum required environment variables — no surplus credentials.
