# XPS Intelligence — Monday MVP Roadmap

**Version:** 1.0.0
**Status:** AUTHORITATIVE
**Owner:** XPS Intelligence Engineering

---

## Objective

Deliver a working revenue intelligence pipeline that ingests real B2B data, normalizes and enriches it, scores leads, and syncs qualified leads to HubSpot — by Monday MVP deadline.

---

## Phase 0: Control Plane (This Repo) — COMPLETE

| Item | Status | Owner |
|------|--------|-------|
| Master blueprint | ✅ DONE | Engineering |
| System contract | ✅ DONE | Engineering |
| Schema definitions | ✅ DONE | Engineering |
| Integration specs | ✅ DONE | Engineering |
| GitHub workflows | ✅ DONE | Engineering |
| Credential strategy | ✅ DONE | Engineering |
| Copilot instructions | ✅ DONE | Engineering |
| GitHub Pages site | ✅ DONE | Engineering |

---

## Phase 1: Core System Bootstrap — SPRINT 1

**Repo:** xps-intelligence-system
**Goal:** Functional pipeline: raw ingest → normalize → enrich → score → activate

| # | Task | Priority | Status |
|---|------|----------|--------|
| 1.1 | Initialize xps-intelligence-system repo from control-plane template | P0 | PLANNED |
| 1.2 | Set up Supabase project, apply schema migrations | P0 | PLANNED |
| 1.3 | Implement raw ingest API endpoint | P0 | PLANNED |
| 1.4 | Implement normalization pipeline (company + contact) | P0 | PLANNED |
| 1.5 | Implement enrichment engine with OpenAI primary | P0 | PLANNED |
| 1.6 | Implement deterministic scoring engine | P0 | PLANNED |
| 1.7 | Implement activation gate | P0 | PLANNED |
| 1.8 | Implement HubSpot sync service | P0 | PLANNED |
| 1.9 | Deploy to Railway with all env vars configured | P0 | PLANNED |
| 1.10 | End-to-end pipeline smoke test with real data | P0 | PLANNED |

---

## Phase 2: Source Adapters — SPRINT 2

**Repo:** xps-source-adapters
**Goal:** Connect 3+ real data sources to the ingest pipeline

| # | Task | Priority | Status |
|---|------|----------|--------|
| 2.1 | Initialize xps-source-adapters repo | P0 | PLANNED |
| 2.2 | Implement Source Adapter 1 (LinkedIn/Apollo) | P0 | PLANNED |
| 2.3 | Implement Source Adapter 2 (ZoomInfo/Clearbit) | P0 | PLANNED |
| 2.4 | Implement Source Adapter 3 (CSV/manual upload) | P0 | PLANNED |
| 2.5 | Register all adapters in source_registry.csv | P0 | PLANNED |
| 2.6 | Validate end-to-end flow from source to HubSpot | P0 | PLANNED |

---

## Phase 3: Workspace Bridge — SPRINT 3

**Repo:** xps-workspace-bridge
**Goal:** Surface intelligence in Google Workspace

| # | Task | Priority | Status |
|---|------|----------|--------|
| 3.1 | Initialize xps-workspace-bridge repo | P1 | PLANNED |
| 3.2 | Implement Google Sheets sync for lead reports | P1 | PLANNED |
| 3.3 | Implement Apps Script trigger for manual activation | P1 | PLANNED |
| 3.4 | Implement Drive report delivery | P2 | PLANNED |

---

## Phase 4: Analytics — SPRINT 4

**Repo:** xps-analytics
**Goal:** Pipeline visibility and conversion measurement

| # | Task | Priority | Status |
|---|------|----------|--------|
| 4.1 | Initialize xps-analytics repo | P1 | PLANNED |
| 4.2 | Build Supabase views for pipeline metrics | P1 | PLANNED |
| 4.3 | Build conversion funnel dashboard | P1 | PLANNED |
| 4.4 | Build source quality report | P2 | PLANNED |

---

## Phase 5: Employee Copilots — SPRINT 5

**Repo:** xps-employee-copilots
**Goal:** AI-powered internal tools for sales and ops

| # | Task | Priority | Status |
|---|------|----------|--------|
| 5.1 | Initialize xps-employee-copilots repo | P2 | PLANNED |
| 5.2 | Build lead research copilot (GPT action) | P2 | PLANNED |
| 5.3 | Build company intel copilot | P2 | PLANNED |
| 5.4 | Build pipeline status copilot | P2 | PLANNED |

---

## Monday MVP Success Criteria

The system is considered MVP-ready when:

- [ ] At least 3 real data sources are connected and ingesting live data.
- [ ] Normalization pipeline processes records with < 5% discard rate.
- [ ] Enrichment runs on 100% of normalized records within 24 hours.
- [ ] Scoring is deterministic and auditable with logged signal values.
- [ ] Leads with score ≥ 70 are automatically synced to HubSpot within 1 hour.
- [ ] HubSpot sync success rate ≥ 95%.
- [ ] All pipeline events are logged and queryable.
- [ ] No mock data, stub services, or placeholder schemas in production.
- [ ] All Railway services are deployed with real environment variables.
- [ ] All Supabase tables have RLS enabled.
