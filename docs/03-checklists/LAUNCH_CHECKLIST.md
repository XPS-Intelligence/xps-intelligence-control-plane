# XPS Intelligence — Launch Checklist

**Version:** 1.0.0
**Status:** AUTHORITATIVE
**Owner:** XPS Intelligence Engineering

---

## How to Use This Checklist

This checklist is the gate for each phase of the system. A phase MUST pass ALL items before the next phase begins. Mark items with ✅ when complete. Do not mark items complete without evidence (linked PR, commit, or verified output).

---

## Gate 0: Control Plane Ready

- [ ] README.md is complete and reflects current system state
- [ ] XPS_MASTER_BLUEPRINT.md is published and reviewed
- [ ] SYSTEM_CONTRACT.md is published and reviewed
- [ ] All schema files pass JSON syntax validation
- [ ] All YAML files pass YAML syntax validation
- [ ] source_registry.csv has at least 1 registered source
- [ ] industry_taxonomy.csv is populated
- [ ] All integration specs are drafted
- [ ] GitHub Actions CI passes
- [ ] GitHub Pages site is published and accessible
- [ ] Credential strategy document is published
- [ ] Copilot instructions are committed to .github/

---

## Gate 1: Infrastructure Ready

- [ ] Supabase project created in correct organization
- [ ] Supabase migrations applied: raw_records, normalized_companies, normalized_contacts, lead_activations, pipeline_events, hubspot_sync_log, score_history, gpt_action_log, api_call_log
- [ ] Supabase RLS enabled on all tables
- [ ] Railway project created
- [ ] Railway environments configured: production, staging
- [ ] All required Railway environment variables set (no placeholders)
- [ ] Railway health check endpoint returns 200
- [ ] HubSpot API key validated against sandbox
- [ ] OpenAI API key validated
- [ ] Groq API key validated (if applicable)

---

## Gate 2: Pipeline Ready (xps-intelligence-system)

- [ ] Repo bootstrapped from control-plane template
- [ ] Ingest API endpoint accepts POST with raw record payload
- [ ] Ingest API validates against raw_source_record.v1.json schema
- [ ] Ingest API writes to Supabase raw_records table
- [ ] Normalization pipeline produces records conforming to company_record.v1.json
- [ ] Normalization pipeline produces records conforming to contact_record.v1.json
- [ ] Enrichment engine calls OpenAI and logs model/version/prompt_hash/response_hash
- [ ] Scoring engine computes deterministic score with logged signal values
- [ ] Activation gate evaluates all criteria from SYSTEM_CONTRACT.md
- [ ] HubSpot sync writes to hubspot_sync_log before executing
- [ ] HubSpot sync updates hubspot_sync_log on success and failure
- [ ] End-to-end smoke test with real data: raw → HubSpot
- [ ] All pipeline events logged to pipeline_events table
- [ ] No mock data, stub services, or placeholder schemas in production

---

## Gate 3: Sources Connected (xps-source-adapters)

- [ ] Minimum 3 source adapters implemented and tested
- [ ] Each adapter registered in source_registry.csv
- [ ] Each adapter submits records conforming to raw_source_record.v1.json
- [ ] Duplicate detection working (source_id + source_record_id)
- [ ] Source quality score populated for each source
- [ ] Error handling: failed records written to raw_records_failed

---

## Gate 4: Workspace Bridge Live (xps-workspace-bridge)

- [ ] Google Workspace OAuth configured
- [ ] Lead report syncs to Google Sheets on schedule
- [ ] Manual activation trigger working from Sheets/Drive
- [ ] Apps Script deployed to correct workspace
- [ ] Report delivery tested with real data

---

## Gate 5: Analytics Operational (xps-analytics)

- [ ] Pipeline metrics Supabase views created
- [ ] Conversion funnel dashboard accessible
- [ ] Source quality report showing per-source metrics
- [ ] Data freshness within acceptable SLA

---

## Gate 6: Production Launch

- [ ] All Gate 0–5 items complete
- [ ] Security review complete
- [ ] Credential rotation schedule confirmed
- [ ] Monitoring and alerting configured
- [ ] Runbooks documented for common failure scenarios
- [ ] On-call rotation defined
- [ ] Data retention policy confirmed in Supabase
- [ ] GDPR/compliance review complete (if applicable)
- [ ] Load test completed for expected data volumes
- [ ] Rollback plan documented
