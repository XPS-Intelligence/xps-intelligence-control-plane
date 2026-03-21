# XPS Intelligence — Copilot Instructions

You are GitHub Copilot operating inside an XPS Intelligence repository.

Read and follow the full Copilot Build Protocol at:
`docs/07-prompts/COPILOT_BUILD_PROTOCOL.md`

The key rules are summarized below. Violations are not acceptable.

---

## Non-Negotiable Rules

1. **No mock data.** All schemas target real production data. Example values are illustrative only and must be marked `// EXAMPLE` or `# EXAMPLE`.

2. **No stub services as complete.** Mark stubs explicitly: `// STUB: not implemented`. Never connect a stub to a live production endpoint.

3. **No hardcoded credentials.** Always use environment variables. Never write an API key, password, or secret in source code.

4. **Fail loud.** Always throw or return explicit errors. Never swallow exceptions silently. Log errors with full context.

5. **Schema conformance.** Data written to Supabase must conform to schemas in `/schemas/`. Data sent to HubSpot must conform to `schemas/crm/hubspot_mapping.v1.json`.

6. **Audit logging.** Log all pipeline state transitions, external API calls, and HubSpot writes before execution.

7. **Build order compliance.** Do not build downstream components that reference upstream components that do not yet exist.

---

## Schema References

- Raw ingest: `schemas/raw/raw_source_record.v1.json`
- Normalized company: `schemas/normalized/company_record.v1.json`
- Normalized contact: `schemas/normalized/contact_record.v1.json`
- Lead activation: `schemas/activation/lead_activation_record.v1.json`
- HubSpot mapping: `schemas/crm/hubspot_mapping.v1.json`
- Ontology: `schemas/ontology/xps_ontology.v1.json`

---

## Environment Variables

All environment variables follow the naming convention defined in:
`docs/05-security/UNIFIED_CREDENTIAL_AND_ENVIRONMENT_STRATEGY.md`

Never invent new environment variable names. Use only names from the canonical registry.

---

## System Contracts

Before writing code, check:
- `docs/01-architecture/SYSTEM_CONTRACT.md` for behavioral contracts
- `integrations/*/` for platform-specific integration specs
- `schemas/` for data contracts

---

## When Uncertain

Output a TODO comment with the specific question. Do not implement a guess.
Do not invent behavior that is not documented in this repository.
