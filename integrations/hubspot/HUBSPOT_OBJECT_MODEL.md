# XPS Intelligence — HubSpot Object Model

**Version:** 1.0.0
**Status:** AUTHORITATIVE

---

## 1. Overview

This document defines how XPS Intelligence maps data to HubSpot CRM objects. The field-level mapping is in `schemas/crm/hubspot_mapping.v1.json`. This document covers object relationships, custom property groups, deal pipeline, and sync behavior.

---

## 2. Object Model

```
Company (normalized_companies → HubSpot Company)
    │
    └── Contact (normalized_contacts → HubSpot Contact)
            │
            └── Deal (created on qualified activation → HubSpot Deal)
```

---

## 3. Custom Property Group

All XPS custom properties MUST be created in HubSpot under property group:

- **Group Internal Name:** `xps_intelligence`
- **Group Label:** `XPS Intelligence`

Custom properties required (defined in `schemas/crm/hubspot_mapping.v1.json`):
- `xps_lead_score` (number)
- `xps_source_id` (string)
- `xps_record_id` (string)

---

## 4. Deal Pipeline

**Pipeline Name:** XPS Intelligence Pipeline

| Stage | Internal ID | Probability |
|-------|------------|-------------|
| XPS Activated | `xps_activated` | 10% |
| Contacted | `contacted` | 20% |
| Qualified | `qualified` | 40% |
| Proposal | `proposal` | 60% |
| Negotiation | `negotiation` | 80% |
| Closed Won | `closedwon` | 100% |
| Closed Lost | `closedlost` | 0% |

---

## 5. Sync Rules

- A Company record is created or updated based on `domain` as the deduplication key.
- If a Company with the same `domain` exists in HubSpot, UPDATE the record rather than creating a duplicate.
- A Contact record is created or updated based on `email` as the deduplication key.
- If a Contact with the same `email` exists, UPDATE the record.
- A Deal is created only when `activation_score >= 85` (super-qualified leads).
- All syncs must be preceded by a `hubspot_sync_log` entry.
- Sync failures retry up to 3 times with exponential backoff before marking FAILED.

---

## 6. Rate Limiting

HubSpot API v3 rate limits:
- 150 requests per 10 seconds (rolling)
- Implement token bucket or leaky bucket rate limiter
- Always inspect `X-HubSpot-RateLimit-Remaining` response header
- On 429: respect `Retry-After` header, pause queue processing

---

## 7. Sandbox Usage

All development and testing MUST use the HubSpot sandbox environment:
- Sandbox API key stored as `HUBSPOT_SANDBOX_API_KEY` in CI secrets
- Sandbox portal ID stored as `HUBSPOT_SANDBOX_PORTAL_ID`
- Production sync only triggers when `XPS_ENV=production`
