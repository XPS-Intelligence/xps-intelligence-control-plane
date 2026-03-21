# XPS Intelligence — Copilot Build Protocol

**Version:** 1.0.0
**Status:** AUTHORITATIVE
**Purpose:** Instructions for GitHub Copilot (and any AI coding assistant) operating in XPS repos.

---

## 1. Identity and Role

When operating in any XPS Intelligence repository, you are building a production revenue intelligence platform. Every file you create or modify is potentially deployed to live infrastructure handling real customer data.

---

## 2. Absolute Rules

### 2.1 No Mock Data
- Do not generate mock data that could be mistaken for production data.
- Example values in code or schemas must be clearly marked with `// EXAMPLE` or `# EXAMPLE` comments.
- Do not seed databases with invented company or contact records.

### 2.2 No Stub Services as Complete
- If you create a stub function, mark it explicitly: `// STUB: not implemented`.
- Never mark a stub as production-ready.
- Never connect a stub to a live production endpoint.

### 2.3 No Hardcoded Credentials
- Never write an API key, password, or secret into source code.
- Always use environment variables: `process.env.VARIABLE_NAME` or equivalent.
- If you need to show an example value for documentation, use: `YOUR_SECRET_HERE` or `<your-key>`.

### 2.4 Fail Loud
- Always throw or return explicit errors. Never swallow exceptions silently.
- Log the error with context: function name, input values (sanitized), error message, stack trace.
- Use structured logging (JSON format preferred).

### 2.5 Schema Conformance
- Any data written to Supabase must conform to the schema defined in `/schemas/`.
- Any data sent to HubSpot must conform to `schemas/crm/hubspot_mapping.v1.json`.
- Validate inputs before processing — use schema validation libraries.

### 2.6 Audit Logging
- Log all pipeline state transitions to `pipeline_events`.
- Log all external API calls to `api_call_log`.
- Log all HubSpot writes to `hubspot_sync_log` before executing.
- Log all enrichment operations with model name, version, prompt hash.

---

## 3. Code Style

- **Language:** TypeScript preferred for Node.js services. Python acceptable for data pipeline workers.
- **Error handling:** Use typed error classes, not generic `Error`.
- **Async:** Use async/await. No raw Promise chains.
- **Environment:** Access via `process.env` with explicit default values or fail-fast validation at startup.
- **Logging:** Use structured JSON logging. Include `service`, `function`, `request_id` in every log line.
- **Comments:** Explain the why, not the what.

---

## 4. When You Are Unsure

If you are unsure whether a change conforms to the system contract:

1. Check `docs/01-architecture/SYSTEM_CONTRACT.md`.
2. Check the relevant schema in `/schemas/`.
3. Check the relevant integration spec in `/integrations/`.
4. If still unsure, output a TODO comment with the specific question and do not implement a guess.

Do not invent behavior. Do not assume a contract exists if it is not documented here.

---

## 5. Build Order Compliance

Always verify you are building in the correct order:

1. control-plane schemas and contracts must exist before system code references them.
2. System pipeline must be functional before source adapters connect to it.
3. Workspace bridge depends on system pipeline being operational.
4. Analytics depends on normalized data existing in Supabase.
5. Employee copilots depend on analytics and system being operational.

Do not build downstream components that reference upstream components that do not yet exist.

---

## 6. PR Requirements

Every PR that modifies schemas must:
- Update the schema version.
- Include a migration plan.
- Pass CI validation.

Every PR that modifies integration contracts must:
- Update the relevant spec file.
- Reference the PR in the integration matrix.

Every PR must:
- Pass all CI checks.
- Have a descriptive title following `[type]: description` format.
- Reference the relevant issue number.
