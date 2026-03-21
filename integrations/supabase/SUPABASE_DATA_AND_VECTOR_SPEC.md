# XPS Intelligence — Supabase Data and Vector Spec

**Version:** 1.0.0
**Status:** AUTHORITATIVE

---

## 1. Project Configuration

- **Extension required:** `pgvector` (for embedding search)
- **Auth:** Supabase Auth enabled; RLS required on all tables
- **Storage:** Supabase Storage for file uploads (CSV ingest)

---

## 2. Core Tables

### 2.1 raw_records

```sql
CREATE TABLE raw_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id TEXT NOT NULL,
  source_record_id TEXT NOT NULL,
  record_type TEXT NOT NULL CHECK (record_type IN ('COMPANY','CONTACT','COMPANY_CONTACT_PAIR','DEAL','UNKNOWN')),
  ingested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  source_created_at TIMESTAMPTZ,
  source_updated_at TIMESTAMPTZ,
  raw_payload JSONB NOT NULL,
  ingest_metadata JSONB,
  status TEXT NOT NULL DEFAULT 'RECEIVED' CHECK (status IN ('RECEIVED','PARSED','NORMALIZED','DISCARDED')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(source_id, source_record_id)
);
CREATE INDEX idx_raw_records_source_id ON raw_records(source_id);
CREATE INDEX idx_raw_records_status ON raw_records(status);
CREATE INDEX idx_raw_records_ingested_at ON raw_records(ingested_at DESC);
```

### 2.2 raw_records_failed

```sql
CREATE TABLE raw_records_failed (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id TEXT,
  source_record_id TEXT,
  raw_payload JSONB,
  failure_reason TEXT NOT NULL,
  failed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  raw_record_attempt JSONB
);
```

### 2.3 normalized_companies

```sql
CREATE TABLE normalized_companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id TEXT NOT NULL,
  raw_record_id UUID REFERENCES raw_records(id),
  normalized_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  status TEXT NOT NULL DEFAULT 'ACTIVE',
  discard_reason TEXT,
  name TEXT NOT NULL,
  name_normalized TEXT,
  domain TEXT,
  domain_verified BOOLEAN DEFAULT false,
  industry TEXT,
  industry_normalized TEXT,
  employee_count INTEGER,
  employee_count_range TEXT,
  revenue_usd NUMERIC,
  revenue_range TEXT,
  founded_year INTEGER,
  city TEXT,
  state TEXT,
  country TEXT,
  country_code CHAR(2),
  linkedin_url TEXT,
  phone TEXT,
  description TEXT,
  description_enriched TEXT,
  tech_stack TEXT[],
  score NUMERIC(5,2),
  score_signals JSONB,
  scored_at TIMESTAMPTZ,
  enrichment_status TEXT,
  enriched_at TIMESTAMPTZ,
  enrichment_model TEXT,
  hubspot_id TEXT,
  hubspot_synced_at TIMESTAMPTZ,
  suppression_reason TEXT,
  embedding VECTOR(1536),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_normalized_companies_domain ON normalized_companies(domain);
CREATE INDEX idx_normalized_companies_status ON normalized_companies(status);
CREATE INDEX idx_normalized_companies_score ON normalized_companies(score DESC);
CREATE INDEX idx_normalized_companies_hubspot_id ON normalized_companies(hubspot_id);
```

### 2.4 normalized_contacts

```sql
CREATE TABLE normalized_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id TEXT NOT NULL,
  raw_record_id UUID REFERENCES raw_records(id),
  company_record_id UUID REFERENCES normalized_companies(id),
  normalized_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  status TEXT NOT NULL DEFAULT 'ACTIVE',
  discard_reason TEXT,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  full_name TEXT,
  email TEXT,
  email_verified BOOLEAN DEFAULT false,
  email_bounced BOOLEAN DEFAULT false,
  phone TEXT,
  title TEXT,
  title_normalized TEXT,
  seniority_level TEXT,
  department TEXT,
  linkedin_url TEXT,
  city TEXT,
  state TEXT,
  country TEXT,
  country_code CHAR(2),
  score NUMERIC(5,2),
  score_signals JSONB,
  scored_at TIMESTAMPTZ,
  enrichment_status TEXT,
  enriched_at TIMESTAMPTZ,
  hubspot_id TEXT,
  hubspot_synced_at TIMESTAMPTZ,
  suppression_reason TEXT,
  embedding VECTOR(1536),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_normalized_contacts_email ON normalized_contacts(email);
CREATE INDEX idx_normalized_contacts_company ON normalized_contacts(company_record_id);
CREATE INDEX idx_normalized_contacts_status ON normalized_contacts(status);
CREATE INDEX idx_normalized_contacts_score ON normalized_contacts(score DESC);
```

### 2.5 lead_activations

```sql
CREATE TABLE lead_activations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_record_id UUID NOT NULL REFERENCES normalized_companies(id),
  contact_record_id UUID REFERENCES normalized_contacts(id),
  activation_triggered_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  activation_score NUMERIC(5,2) NOT NULL,
  activation_score_signals JSONB,
  status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','SYNCING','SYNCED','FAILED','SUPPRESSED')),
  hubspot_company_id TEXT,
  hubspot_contact_id TEXT,
  hubspot_deal_id TEXT,
  sync_started_at TIMESTAMPTZ,
  sync_completed_at TIMESTAMPTZ,
  failure_reason TEXT,
  failure_count INTEGER DEFAULT 0,
  suppression_reason TEXT,
  suppressed_at TIMESTAMPTZ,
  sync_log_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 2.6 hubspot_sync_log

```sql
CREATE TABLE hubspot_sync_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  activation_id UUID REFERENCES lead_activations(id),
  object_type TEXT NOT NULL CHECK (object_type IN ('COMPANY','CONTACT','DEAL','ASSOCIATION')),
  operation TEXT NOT NULL CHECK (operation IN ('CREATE','UPDATE','ASSOCIATE')),
  xps_record_id UUID NOT NULL,
  hubspot_id TEXT,
  payload JSONB NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','SYNCED','FAILED')),
  failure_reason TEXT,
  attempt_number INTEGER DEFAULT 1,
  attempted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ
);
CREATE INDEX idx_hubspot_sync_log_activation ON hubspot_sync_log(activation_id);
CREATE INDEX idx_hubspot_sync_log_status ON hubspot_sync_log(status);
```

### 2.7 pipeline_events

```sql
CREATE TABLE pipeline_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL,
  source_id TEXT,
  record_id UUID,
  record_type TEXT,
  previous_status TEXT,
  new_status TEXT,
  metadata JSONB,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_pipeline_events_record_id ON pipeline_events(record_id);
CREATE INDEX idx_pipeline_events_event_type ON pipeline_events(event_type);
CREATE INDEX idx_pipeline_events_occurred_at ON pipeline_events(occurred_at DESC);
```

### 2.8 score_history

```sql
CREATE TABLE score_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  record_id UUID NOT NULL,
  record_type TEXT NOT NULL CHECK (record_type IN ('COMPANY','CONTACT')),
  previous_score NUMERIC(5,2),
  new_score NUMERIC(5,2) NOT NULL,
  score_signals JSONB,
  scored_by TEXT NOT NULL,
  scored_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 2.9 api_call_log

```sql
CREATE TABLE api_call_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service TEXT NOT NULL,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER,
  latency_ms INTEGER,
  request_id TEXT,
  error_message TEXT,
  called_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_api_call_log_service ON api_call_log(service);
CREATE INDEX idx_api_call_log_called_at ON api_call_log(called_at DESC);
```

### 2.10 gpt_action_log

```sql
CREATE TABLE gpt_action_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action_type TEXT NOT NULL,
  action_endpoint TEXT NOT NULL,
  request_payload JSONB,
  response_payload JSONB,
  is_write_action BOOLEAN NOT NULL DEFAULT false,
  confirmed BOOLEAN DEFAULT false,
  justification TEXT,
  status TEXT NOT NULL CHECK (status IN ('PENDING','EXECUTED','FAILED','REJECTED')),
  executed_at TIMESTAMPTZ,
  requested_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

---

## 3. Row Level Security

RLS must be enabled on all tables. Base policies:

```sql
-- Enable RLS on all tables
ALTER TABLE raw_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE normalized_companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE normalized_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE lead_activations ENABLE ROW LEVEL SECURITY;
ALTER TABLE hubspot_sync_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE pipeline_events ENABLE ROW LEVEL SECURITY;

-- Service role bypasses RLS (server-side only)
-- Anon key has NO access to any of these tables
-- Define additional policies per use case in xps-intelligence-system
```

---

## 4. Vector Search

The `embedding` column (VECTOR(1536)) on `normalized_companies` and `normalized_contacts` supports semantic similarity search using OpenAI text-embedding-3-small (1536 dimensions).

```sql
-- Example similarity search
SELECT id, name, domain, 1 - (embedding <=> $1) AS similarity
FROM normalized_companies
WHERE 1 - (embedding <=> $1) > 0.8
ORDER BY similarity DESC
LIMIT 10;
```
