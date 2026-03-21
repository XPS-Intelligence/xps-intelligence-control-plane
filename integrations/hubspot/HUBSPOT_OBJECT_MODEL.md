# HubSpot Object Model

> This document defines the HubSpot CRM object model used by XPS Intelligence. All custom properties must be created before the activation pipeline can push records.

---

## 1. Object Types Used

| Object | Purpose |
|--------|---------|
| **Company** | Represents a target account (maps from `CompanyRecord`) |
| **Contact** | Represents a decision-maker at a target account |
| **Deal** | Created automatically by HubSpot workflows (not created by XPS pipeline) |

---

## 2. Company Object Properties

### 2.1 Built-in HubSpot Properties (used by XPS)

| HubSpot Property | Type | XPS Source Field | Notes |
|-----------------|------|-----------------|-------|
| `name` | Single-line text | `company_record.name` | Required for all company objects |
| `domain` | Single-line text | `company_record.domain` | Used as deduplication key by HubSpot |
| `description` | Multi-line text | `company_record.description` | |
| `industry` | Dropdown | `company_record.industry` | Must map to HubSpot industry enum values |
| `country` | Single-line text | `company_record.hq_country` | ISO 3166-1 alpha-2 |
| `city` | Single-line text | `company_record.hq_city` | |
| `linkedin_company_page` | Single-line text | `company_record.linkedin_url` | |
| `founded_year` | Number | `company_record.founded_year` | |

### 2.2 Custom XPS Properties (must be created)

All custom properties live in the **"XPS Intelligence"** property group.

| Property Name | Label | Type | XPS Source Field | Notes |
|--------------|-------|------|-----------------|-------|
| `xps_company_id` | XPS Company ID | Single-line text | `company_record.company_id` | Internal UUID for cross-referencing |
| `xps_employee_range` | XPS Employee Range | Dropdown | `company_record.employee_range` | See enum values below |
| `xps_revenue_range` | XPS Revenue Range | Dropdown | `company_record.revenue_range` | See enum values below |
| `xps_lifecycle_stage` | XPS Lifecycle Stage | Dropdown | `company_record.lifecycle_stage` | See enum values below |
| `xps_technologies` | XPS Technologies | Single-line text | `company_record.technologies` | Comma-separated list |
| `xps_enrichment_score` | XPS Enrichment Score | Number | `company_record.enrichment_score` | 0–100 |
| `xps_activation_score` | XPS Activation Score | Number | `activation_record.activation_score` | 0–100 at time of push |
| `xps_source_ids` | XPS Source IDs | Single-line text | `company_record.source_ids` | Semicolon-separated list |

#### `xps_employee_range` Enum Values
`1-10`, `11-50`, `51-200`, `201-500`, `501-1000`, `1001-5000`, `5001-10000`, `10001+`

#### `xps_revenue_range` Enum Values
`< $1M`, `$1M - $10M`, `$10M - $50M`, `$50M - $100M`, `$100M - $500M`, `$500M - $1B`, `> $1B`

#### `xps_lifecycle_stage` Enum Values
`pre-seed`, `seed`, `series-a`, `series-b`, `series-c+`, `growth`, `established`, `enterprise`, `unknown`

---

## 3. Contact Object Properties

### 3.1 Built-in HubSpot Properties (used by XPS)

| HubSpot Property | Type | XPS Source Field | Notes |
|-----------------|------|-----------------|-------|
| `email` | Email | `activation_record.contact_email` | Primary deduplication key |
| `firstname` | Single-line text | `activation_record.contact_first_name` | |
| `lastname` | Single-line text | `activation_record.contact_last_name` | |
| `jobtitle` | Single-line text | `activation_record.contact_title` | |

### 3.2 Custom XPS Contact Properties

| Property Name | Label | Type | XPS Source Field | Notes |
|--------------|-------|------|-----------------|-------|
| `xps_contact_seniority` | XPS Contact Seniority | Dropdown | `activation_record.contact_seniority` | See enum values below |

#### `xps_contact_seniority` Enum Values
`c-suite`, `vp`, `director`, `manager`, `individual-contributor`, `founder`, `unknown`

---

## 4. Creating Custom Properties

### Via HubSpot UI

1. Go to **Settings** → **Properties**
2. Select **Company properties** or **Contact properties**
3. Click **Create property**
4. For **Group**, create or select **"XPS Intelligence"**
5. Fill in the property name, label, and type per the tables above

### Via HubSpot API

Use the Properties API to create custom properties programmatically. Reference the full mapping in `schemas/crm/hubspot_mapping.v1.json`.

Example API call (create `xps_enrichment_score`):
```bash
curl -X POST \
  "https://api.hubapi.com/crm/v3/properties/companies" \
  -H "Authorization: Bearer $HUBSPOT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "xps_enrichment_score",
    "label": "XPS Enrichment Score",
    "type": "number",
    "fieldType": "number",
    "groupName": "xps_intelligence",
    "description": "XPS Intelligence data completeness score (0-100)"
  }'
```

---

## 5. Deduplication Logic

HubSpot automatically deduplicates:
- **Companies** by `domain`
- **Contacts** by `email`

The XPS activation service checks for existing records before creating new ones:

1. Search for company by `domain` → if found, update; if not, create
2. Search for contact by `email` → if found, update; if not, create
3. Associate contact with company using the HubSpot Association API

---

## 6. API Rate Limits

| Tier | Limit |
|------|-------|
| Free / Starter | 100 requests per 10 seconds |
| Professional / Enterprise | 150 requests per 10 seconds |

The activation service implements:
- Request batching (up to 100 companies per batch API call)
- Exponential back-off on 429 responses
- Queue-based processing to stay within rate limits

---

## 7. Required HubSpot Private App Scopes

When creating the HubSpot Private App, grant the following scopes:

| Scope | Object | Permission |
|-------|--------|-----------|
| `crm.objects.companies.read` | Company | Read |
| `crm.objects.companies.write` | Company | Write |
| `crm.objects.contacts.read` | Contact | Read |
| `crm.objects.contacts.write` | Contact | Write |
| `crm.schemas.companies.read` | Company schema | Read |
| `crm.schemas.companies.write` | Company schema | Write (for creating custom properties) |
| `crm.schemas.contacts.read` | Contact schema | Read |
| `crm.schemas.contacts.write` | Contact schema | Write |
| `crm.associations.read` | Associations | Read |
| `crm.associations.write` | Associations | Write |
