# XPS Intelligence — Integration Matrix

**Version:** 1.0.0
**Status:** AUTHORITATIVE

---

## Integration Overview

| Integration | Direction | Protocol | Auth Method | Status |
|-------------|-----------|----------|-------------|--------|
| Supabase ↔ xps-intelligence-system | Bidirectional | Supabase client (REST/Realtime) | Service Role Key | PLANNED |
| HubSpot ← xps-intelligence-system | Write | REST API v3 | API Key | PLANNED |
| OpenAI ← xps-intelligence-system | Read (API call) | REST API | API Key | PLANNED |
| Groq ← xps-intelligence-system | Read (API call) | REST API | API Key | PLANNED |
| Railway ← GitHub Actions | Deploy | Railway CLI | Deploy Token | PLANNED |
| Google Sheets ← xps-workspace-bridge | Write | Google Sheets API | Service Account | PLANNED |
| Google Drive ← xps-workspace-bridge | Write | Google Drive API | Service Account | PLANNED |
| ElevenLabs ← xps-employee-copilots | Read (audio) | REST API | API Key | PLANNED |
| Ollama ← xps-intelligence-system | Read (API call) | REST API | None/API Key | PLANNED |

---

## Integration Detail

### Supabase
- **SDK:** `@supabase/supabase-js` (JS/TS services) or `supabase-py` (Python services)
- **Tables used:** raw_records, normalized_companies, normalized_contacts, lead_activations, pipeline_events, hubspot_sync_log, score_history, gpt_action_log, api_call_log
- **RLS:** Required on all tables
- **Realtime:** Used for pipeline event streaming to dashboards
- **Vector:** pgvector extension for embedding search

### HubSpot
- **API version:** v3
- **Objects:** Contacts, Companies, Deals, Engagements
- **Rate limit:** 150 requests/10 seconds; pipeline must respect this
- **Sandbox:** Required for all development and testing
- **Schema:** `schemas/crm/hubspot_mapping.v1.json`
- **Spec:** `integrations/hubspot/HUBSPOT_OBJECT_MODEL.md`

### OpenAI
- **Models:** gpt-4o (primary enrichment), gpt-4o-mini (batch/cost-optimized)
- **Use cases:** Company description enrichment, industry classification, tech stack inference, GPT actions
- **Rate limits:** Tier-dependent; implement exponential backoff
- **Spec:** `integrations/openai/OPENAI_GPT_ACTIONS_SCHEMA.md`

### Google Workspace
- **APIs:** Google Sheets API v4, Google Drive API v3
- **Auth:** Service account with domain-wide delegation (if required)
- **Spec:** `integrations/google/GOOGLE_WORKSPACE_BRIDGE_SPEC.md`

### Railway
- **Deploy method:** Railway CLI via GitHub Actions
- **Environments:** production, staging
- **Spec:** `integrations/railway/ENVIRONMENT_CONTRACT.md`

---

## Integration Failure Modes

| Integration | Failure Mode | Handling |
|-------------|-------------|----------|
| Supabase write | Connection timeout | Retry 3x with exponential backoff; log failure |
| HubSpot API | Rate limit (429) | Respect Retry-After header; queue pending writes |
| HubSpot API | Auth failure (401) | Fail loud; alert; do not retry until key confirmed |
| OpenAI API | Rate limit (429) | Fall back to Groq; log fallback |
| OpenAI API | Timeout | Retry 2x; fall back to Groq; log |
| Google Sheets | Auth failure | Fail loud; do not write partial data |
| Railway deploy | Build failure | Fail CI; do not deploy |
