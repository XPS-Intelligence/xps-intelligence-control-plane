# Supabase Setup Guide

> This guide covers provisioning and configuring the Supabase project used as the XPS Intelligence database layer.

---

## 1. Project Creation

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **New project**
3. Fill in:
   - **Organization:** XPS Intelligence
   - **Project name:** `xps-intelligence-prod` (or `-staging`)
   - **Database password:** Generate a strong password and store in 1Password
   - **Region:** Choose the region closest to your Railway deployment (e.g., `us-east-1`)
4. Click **Create new project** and wait for provisioning (~2 minutes)

---

## 2. Retrieve API Keys

After provisioning, go to **Project Settings** → **API**:

| Key | Variable Name | Usage |
|-----|--------------|-------|
| `URL` | `SUPABASE_URL` | All services |
| `anon` (public) | `SUPABASE_ANON_KEY` | Client-side read-only access |
| `service_role` (secret) | `SUPABASE_SERVICE_ROLE_KEY` | Server-side workers (bypasses RLS) |

Copy these values to Railway environment variables and GitHub Actions secrets as described in `integrations/railway/ENVIRONMENT_CONTRACT.md`.

> ⚠️ Never commit the `service_role` key to source code.

---

## 3. Database Schema

Run the following SQL migrations in the **Supabase SQL Editor** (Project → SQL Editor → New query).

### 3.1 Create `raw_records` table

```sql
CREATE TABLE IF NOT EXISTS raw_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schema_version TEXT NOT NULL DEFAULT 'raw/v1',
    source_id TEXT NOT NULL,
    record_hash TEXT NOT NULL,
    raw_payload JSONB NOT NULL,
    ingested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    crawler_version TEXT,
    tags TEXT[],
    source_url TEXT,
    http_status INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Deduplication index: one record per source+hash combination
CREATE UNIQUE INDEX IF NOT EXISTS raw_records_source_hash_idx
    ON raw_records (source_id, record_hash);

-- Query index: fetch by source
CREATE INDEX IF NOT EXISTS raw_records_source_id_idx
    ON raw_records (source_id);

-- Query index: fetch by ingestion time
CREATE INDEX IF NOT EXISTS raw_records_ingested_at_idx
    ON raw_records (ingested_at DESC);

COMMENT ON TABLE raw_records IS 'Immutable raw source records as ingested from registered data sources.';
```

### 3.2 Create `company_records` table

```sql
CREATE TABLE IF NOT EXISTS company_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schema_version TEXT NOT NULL DEFAULT 'normalized/v1',
    company_id UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    domain TEXT NOT NULL UNIQUE,
    industry TEXT,
    industry_sub TEXT,
    company_type TEXT,
    lifecycle_stage TEXT,
    employee_range TEXT,
    revenue_range TEXT,
    hq_country CHAR(2),
    hq_city TEXT,
    hq_state TEXT,
    description TEXT,
    linkedin_url TEXT,
    twitter_handle TEXT,
    founded_year INTEGER,
    technologies TEXT[],
    funding_total_usd NUMERIC,
    last_funding_round TEXT,
    source_ids TEXT[] NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    enrichment_score NUMERIC CHECK (enrichment_score >= 0 AND enrichment_score <= 100),
    is_suppressed BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS company_records_domain_idx
    ON company_records (domain);

CREATE INDEX IF NOT EXISTS company_records_enrichment_score_idx
    ON company_records (enrichment_score DESC)
    WHERE is_suppressed = FALSE;

CREATE INDEX IF NOT EXISTS company_records_updated_at_idx
    ON company_records (updated_at DESC);

COMMENT ON TABLE company_records IS 'Canonical normalized company records produced by the normalization pipeline.';
```

### 3.3 Create `lead_activation_records` table

```sql
CREATE TABLE IF NOT EXISTS lead_activation_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schema_version TEXT NOT NULL DEFAULT 'activation/v1',
    activation_id UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company_records(company_id),
    contact_name TEXT,
    contact_first_name TEXT,
    contact_last_name TEXT,
    contact_email TEXT,
    contact_title TEXT,
    contact_linkedin_url TEXT,
    contact_seniority TEXT,
    intent_signals JSONB,
    activation_score NUMERIC NOT NULL CHECK (activation_score >= 0 AND activation_score <= 100),
    score_factors JSONB,
    hubspot_company_id TEXT,
    hubspot_contact_id TEXT,
    activated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'pushed', 'failed', 'suppressed', 'duplicate')),
    error_code TEXT,
    error_message TEXT,
    retry_count INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS lead_activation_company_id_idx
    ON lead_activation_records (company_id);

CREATE INDEX IF NOT EXISTS lead_activation_status_idx
    ON lead_activation_records (status);

CREATE INDEX IF NOT EXISTS lead_activation_score_idx
    ON lead_activation_records (activation_score DESC);

COMMENT ON TABLE lead_activation_records IS 'Records of lead activation events pushed to HubSpot CRM.';
```

### 3.4 Create `dead_letter_queue` table

```sql
CREATE TABLE IF NOT EXISTS dead_letter_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pipeline_stage TEXT NOT NULL
        CHECK (pipeline_stage IN ('ingestion', 'normalization', 'enrichment', 'activation')),
    source_record_id UUID,
    company_id UUID,
    error_code TEXT,
    error_message TEXT NOT NULL,
    raw_payload JSONB,
    failed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,
    is_resolved BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS dlq_unresolved_idx
    ON dead_letter_queue (pipeline_stage, failed_at DESC)
    WHERE is_resolved = FALSE;

COMMENT ON TABLE dead_letter_queue IS 'Failed records from any pipeline stage for manual inspection and retry.';
```

---

## 4. Row-Level Security (RLS)

Enable RLS on all tables and configure policies:

```sql
-- Enable RLS
ALTER TABLE raw_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE company_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE lead_activation_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE dead_letter_queue ENABLE ROW LEVEL SECURITY;

-- Service role has full access (bypasses RLS automatically)
-- Anon users: no access
-- Add additional policies here if client-facing access is needed in future
```

---

## 5. Verify Setup

Run this query to confirm all tables exist:

```sql
SELECT table_name, pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) AS size
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('raw_records', 'company_records', 'lead_activation_records', 'dead_letter_queue')
ORDER BY table_name;
```

Expected output: 4 rows returned.

---

## 6. Connection Pooling

For high-volume workloads, use Supabase's built-in PgBouncer connection pooler:

- In Project Settings → Database → Connection Pooling, enable **Transaction mode**
- Use the pooler connection string (port `6543`) for worker services
- Use the direct connection string (port `5432`) for migrations only

---

## 7. Backup and Recovery

- Supabase Pro plans include daily automated backups (7-day retention)
- For production, enable **Point-in-Time Recovery** in Project Settings → Database
- Test restore procedure quarterly
