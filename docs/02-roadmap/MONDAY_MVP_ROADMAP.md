# Monday MVP Roadmap

> **Goal:** Ship a working end-to-end intelligence pipeline by end of sprint zero (Monday launch).

---

## Sprint Zero Objectives

By Monday we must demonstrate:

1. ✅ At least **3 active sources** registered and crawling
2. ✅ Raw records flowing into Supabase `raw_records` table
3. ✅ Normalization pipeline producing `company_records`
4. ✅ Nightly enrichment running without errors
5. ✅ At least **10 activated leads** pushed to HubSpot
6. ✅ CI pipeline green on `main`
7. ✅ Railway deployment stable in production environment

---

## Day-by-Day Plan

### Day 1 — Foundation

| # | Task | Owner | Status |
|---|------|-------|--------|
| 1.1 | Provision Supabase project and run schema migrations | Infra | ⬜ |
| 1.2 | Deploy Railway environment with environment variables set | Infra | ⬜ |
| 1.3 | Validate `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` connectivity | Infra | ⬜ |
| 1.4 | Register first 3 sources in `source_registry.csv` | Data | ⬜ |
| 1.5 | Scaffold first crawler adapter (web scraper) | Engineering | ⬜ |

### Day 2 — Ingestion

| # | Task | Owner | Status |
|---|------|-------|--------|
| 2.1 | Wire crawler output → RawSourceRecord schema | Engineering | ⬜ |
| 2.2 | Implement Supabase upsert with deduplication (hash-based) | Engineering | ⬜ |
| 2.3 | Validate 100+ raw records landing in Supabase | QA | ⬜ |
| 2.4 | Smoke test CI workflow passes (`crawler-smoke.yml`) | Engineering | ⬜ |
| 2.5 | Add second source adapter | Engineering | ⬜ |

### Day 3 — Normalization

| # | Task | Owner | Status |
|---|------|-------|--------|
| 3.1 | Build normalization worker per `company_record.v1.json` | Engineering | ⬜ |
| 3.2 | Implement entity resolution (domain dedup) | Engineering | ⬜ |
| 3.3 | Validate normalized records in `company_records` table | QA | ⬜ |
| 3.4 | Add industry taxonomy mapping | Data | ⬜ |
| 3.5 | Unit tests for normalization logic | Engineering | ⬜ |

### Day 4 — Enrichment

| # | Task | Owner | Status |
|---|------|-------|--------|
| 4.1 | Build enrichment service skeleton | Engineering | ⬜ |
| 4.2 | Integrate OpenAI for description and classification | Engineering | ⬜ |
| 4.3 | Schedule nightly enrichment workflow (`nightly-enrich.yml`) | DevOps | ⬜ |
| 4.4 | Validate enrichment score > 70 for ≥ 80% of records | QA | ⬜ |
| 4.5 | Configure dead-letter queue for failed enrichments | Engineering | ⬜ |

### Day 5 — Activation

| # | Task | Owner | Status |
|---|------|-------|--------|
| 5.1 | Build HubSpot activation service | Engineering | ⬜ |
| 5.2 | Map enriched fields → HubSpot properties (per `hubspot_mapping.v1.json`) | Engineering | ⬜ |
| 5.3 | Push first 10 leads to HubSpot sandbox | Engineering | ⬜ |
| 5.4 | Validate HubSpot Company + Contact objects created correctly | QA | ⬜ |
| 5.5 | Promote to HubSpot production after QA sign-off | Engineering | ⬜ |

### Day 6 — Hardening & Launch

| # | Task | Owner | Status |
|---|------|-------|--------|
| 6.1 | Run full end-to-end smoke test | QA | ⬜ |
| 6.2 | Confirm all CI workflows green | DevOps | ⬜ |
| 6.3 | Complete Launch Checklist (`docs/03-checklists/LAUNCH_CHECKLIST.md`) | All | ⬜ |
| 6.4 | Deploy to Railway production (`deploy-railway.yml`) | DevOps | ⬜ |
| 6.5 | Share demo with stakeholders | Product | ⬜ |

---

## MVP Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Sources active | ≥ 3 | Source registry count |
| Raw records ingested | ≥ 500 | Supabase row count |
| Normalized companies | ≥ 200 | Supabase row count |
| Enrichment coverage | ≥ 80% | enrichment_score > 0 |
| Leads activated in HubSpot | ≥ 10 | HubSpot company count |
| CI pass rate | 100% | GitHub Actions |
| Pipeline uptime | ≥ 95% | Railway metrics |

---

## Risks and Mitigations

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Source website blocks crawler | Medium | High | Implement rate limiting + user-agent rotation |
| HubSpot API rate limit (100 req/10s) | Low | Medium | Batch activations with queue |
| OpenAI API latency | Medium | Low | Cache enrichment results for 24h |
| Supabase connection pool exhausted | Low | High | Use connection pooler (pgBouncer) |
| Normalization false duplicates | Medium | Medium | Human review queue for low-confidence merges |

---

## Post-MVP Backlog (Week 2+)

- [ ] Add 10+ additional sources
- [ ] Build self-serve source onboarding UI
- [ ] Implement full contact discovery (name + email)
- [ ] HubSpot deal creation on high-intent signals
- [ ] Slack alerting for newly activated leads
- [ ] Google Sheets dashboard bridge (Apps Script)
- [ ] Multi-tenant support
