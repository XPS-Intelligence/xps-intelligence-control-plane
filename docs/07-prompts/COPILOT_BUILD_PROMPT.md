# Copilot Build Prompt

> Use this prompt when asking GitHub Copilot or Copilot Chat to implement specific features in this repository. Provide this context so Copilot generates code consistent with project conventions.

---

## Standard Context Block

Prepend this to any Copilot Chat request:

```
Context: XPS Intelligence Control Plane (xps-intelligence-control-plane repo)

Architecture:
- 4-stage pipeline: Ingestion → Normalization → Enrichment → Activation
- Database: Supabase (PostgreSQL)
- Compute: Railway (Python or Node.js services)
- CRM: HubSpot

Key files to respect:
- schemas/raw/raw_source_record.v1.json — shape of inbound records
- schemas/normalized/company_record.v1.json — canonical company shape
- schemas/crm/hubspot_mapping.v1.json — HubSpot field mapping
- seed/source-registry/source_registry.csv — registered data sources

Conventions:
- Python ≥ 3.11 or Node.js ≥ 18
- All schemas follow JSON Schema draft-07
- Record IDs are UUIDv4
- Timestamps are ISO 8601 UTC
- Dedup raw records by SHA-256(raw_payload)
- Dedup companies by domain
- Secrets via environment variables (never hardcoded)
- Structured JSON logging to stdout
- Retry with exponential back-off for external API calls

Task:
```

---

## Task-Specific Prompts

### Add a New Source Adapter

```
Using the XPS Intelligence context above, implement a new source adapter for [SOURCE_NAME].

Source details:
- source_id: [source_id_slug]
- base_url: [https://...]
- crawler_type: [web|api|rss]
- refresh_cadence: [nightly|daily|weekly]

The adapter must:
1. Fetch data from the source URL
2. Transform each item into a RawSourceRecord conforming to schemas/raw/raw_source_record.v1.json
3. Generate a SHA-256 hash of the raw_payload for deduplication
4. Upsert into Supabase `raw_records` table (skip on duplicate hash)
5. Implement rate limiting at CRAWLER_RATE_LIMIT_RPS requests/second
6. Log results as structured JSON: { source_id, records_fetched, records_inserted, records_skipped }

Return a single Python module at `adapters/[source_id].py`.
```

### Implement Normalization for a Source

```
Using the XPS Intelligence context above, implement the normalization mapping for source_id: [source_id].

The normalizer must:
1. Read raw records from Supabase `raw_records` WHERE source_id = '[source_id]' AND processed = false
2. Extract fields from raw_payload according to this mapping:
   [paste field mapping here, e.g.:]
   - raw_payload.company_name → name
   - raw_payload.website → domain
   - raw_payload.size → employee_range (map to ontology enum)
3. Produce a CompanyRecord conforming to schemas/normalized/company_record.v1.json
4. Upsert into Supabase `company_records` table, deduplicating by domain
5. Mark source raw record as processed
6. Write failures to `dead_letter_queue`

Return a Python module at `normalizers/[source_id].py`.
```

### Implement Enrichment Logic

```
Using the XPS Intelligence context above, implement an enrichment function that augments a CompanyRecord.

The enrichment must:
1. Accept a CompanyRecord (company_id) as input
2. Call OpenAI (model: OPENAI_MODEL env var, default gpt-4o-mini) to generate:
   - A concise company description (max 300 chars) based on name, domain, and industry
   - A classification of lifecycle_stage from the ontology enum
3. Update the CompanyRecord in Supabase with enriched fields
4. Recalculate enrichment_score (% of optional fields populated)
5. Update updated_at timestamp
6. Return the updated enrichment_score

Use the OpenAI Python SDK. Handle rate limits with exponential back-off.
```

### Implement HubSpot Activation

```
Using the XPS Intelligence context above, implement the HubSpot activation function.

The activator must:
1. Accept a LeadActivationRecord (activation_id) as input
2. Map CompanyRecord fields to HubSpot properties per schemas/crm/hubspot_mapping.v1.json
3. Search HubSpot for existing Company by domain → update if found, create if not
4. If contact_email is present, search for existing Contact → update if found, create if not
5. Associate Contact with Company
6. Store hubspot_company_id and hubspot_contact_id back in Supabase
7. Update activation status to 'pushed' or 'failed'
8. On failure, increment retry_count and write to dead_letter_queue

Use the hubspot-api-client Python library. Handle 429 rate limits with back-off.
```

---

## Code Quality Requirements

When Copilot generates code for this project, it must:

- [ ] Include type hints (Python) or TypeScript types
- [ ] Include structured JSON logging (not print statements)
- [ ] Include error handling that writes to `dead_letter_queue` on failure
- [ ] Not hardcode any credentials
- [ ] Include a brief docstring explaining the function's purpose
- [ ] Follow the existing naming conventions (snake_case for Python, camelCase for JS/TS)
