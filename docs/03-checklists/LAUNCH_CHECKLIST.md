# Launch Checklist

> Complete every item before promoting to production. All items must be checked off by the responsible owner. A second reviewer must sign off on each section.

---

## Section 1 — Infrastructure

| # | Check | Owner | Verified By | Status |
|---|-------|-------|-------------|--------|
| 1.1 | Supabase project provisioned in production region | Infra | | ⬜ |
| 1.2 | All Supabase table migrations applied (`raw_records`, `company_records`, `dead_letter_queue`) | Infra | | ⬜ |
| 1.3 | Row-Level Security (RLS) enabled on all tables | Infra | | ⬜ |
| 1.4 | Railway production environment deployed and healthy | DevOps | | ⬜ |
| 1.5 | All required environment variables set in Railway (see `ENVIRONMENT_CONTRACT.md`) | DevOps | | ⬜ |
| 1.6 | No secrets committed to source code (run `git log --all -S "sk-"` check) | Security | | ⬜ |
| 1.7 | Railway service health checks passing | DevOps | | ⬜ |

## Section 2 — Data Pipeline

| # | Check | Owner | Verified By | Status |
|---|-------|-------|-------------|--------|
| 2.1 | All registered sources in `source_registry.csv` have working crawlers | Engineering | | ⬜ |
| 2.2 | Raw records ingesting without errors for 24+ hours | Engineering | | ⬜ |
| 2.3 | Deduplication working (no duplicate `record_hash` per `source_id`) | Engineering | | ⬜ |
| 2.4 | Normalization pipeline producing valid `company_records` | Engineering | | ⬜ |
| 2.5 | Entity resolution tested with known duplicate fixtures | QA | | ⬜ |
| 2.6 | Dead letter queue monitored and alert configured | DevOps | | ⬜ |
| 2.7 | Nightly enrichment workflow scheduled and tested | DevOps | | ⬜ |

## Section 3 — CRM Integration

| # | Check | Owner | Verified By | Status |
|---|-------|-------|-------------|--------|
| 3.1 | HubSpot private app created with minimum required scopes | Engineering | | ⬜ |
| 3.2 | `HUBSPOT_API_KEY` set in Railway (not exposed in code) | Security | | ⬜ |
| 3.3 | HubSpot Company custom properties created per `HUBSPOT_OBJECT_MODEL.md` | Engineering | | ⬜ |
| 3.4 | HubSpot Contact custom properties created | Engineering | | ⬜ |
| 3.5 | At least 10 test leads successfully pushed to HubSpot sandbox | QA | | ⬜ |
| 3.6 | HubSpot sandbox sign-off complete; ready to promote to production portal | Product | | ⬜ |
| 3.7 | Activation status correctly reflected in Supabase `lead_activation_records` | QA | | ⬜ |

## Section 4 — CI/CD

| # | Check | Owner | Verified By | Status |
|---|-------|-------|-------------|--------|
| 4.1 | `ci.yml` passing on latest `main` commit | DevOps | | ⬜ |
| 4.2 | `crawler-smoke.yml` passing (smoke tests green) | DevOps | | ⬜ |
| 4.3 | `deploy-railway.yml` successfully deploys to staging | DevOps | | ⬜ |
| 4.4 | `nightly-enrich.yml` successfully completes a dry-run | DevOps | | ⬜ |
| 4.5 | Branch protection rules enabled on `main` | DevOps | | ⬜ |
| 4.6 | Required PR review count set to ≥ 1 | DevOps | | ⬜ |

## Section 5 — Security

| # | Check | Owner | Verified By | Status |
|---|-------|-------|-------------|--------|
| 5.1 | All API keys rotated from development values | Security | | ⬜ |
| 5.2 | Supabase service role key NOT used in client-facing code | Security | | ⬜ |
| 5.3 | All outbound requests use HTTPS | Engineering | | ⬜ |
| 5.4 | Rate limiting in place for all crawlers | Engineering | | ⬜ |
| 5.5 | PII handling reviewed (contact emails stored securely) | Security | | ⬜ |
| 5.6 | Supabase `anon` key has no write access | Infra | | ⬜ |

## Section 6 — Observability

| # | Check | Owner | Verified By | Status |
|---|-------|-------|-------------|--------|
| 6.1 | Structured JSON logs emitted by all services | Engineering | | ⬜ |
| 6.2 | Railway log drain configured | DevOps | | ⬜ |
| 6.3 | Nightly enrichment summary notifications configured | DevOps | | ⬜ |
| 6.4 | Dead letter queue alert firing correctly on test failure | QA | | ⬜ |
| 6.5 | Dashboard / monitoring view accessible to team | Product | | ⬜ |

## Section 7 — Documentation

| # | Check | Owner | Verified By | Status |
|---|-------|-------|-------------|--------|
| 7.1 | README.md reflects current architecture | Engineering | | ⬜ |
| 7.2 | `XPS_MASTER_BLUEPRINT.md` up to date | Engineering | | ⬜ |
| 7.3 | `SYSTEM_CONTRACT.md` matches deployed schema versions | Engineering | | ⬜ |
| 7.4 | All integration docs reviewed and accurate | Engineering | | ⬜ |
| 7.5 | Runbook for common failure scenarios documented | DevOps | | ⬜ |

---

## Sign-off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Engineering Lead | | | |
| Product Owner | | | |
| Security Reviewer | | | |
| DevOps | | | |

> **Launch is BLOCKED until all checkboxes are filled and sign-off table is complete.**
