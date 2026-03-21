# XPS Intelligence — Google Workspace Bridge Spec

**Version:** 1.0.0
**Status:** AUTHORITATIVE

---

## 1. Purpose

The Google Workspace Bridge connects XPS Intelligence pipeline outputs to Google Workspace (Sheets, Drive) for reporting and manual workflow triggers.

---

## 2. Authentication

- **Method:** Google Service Account with JSON key file
- **Credential variable:** `GOOGLE_SERVICE_ACCOUNT_JSON`
- **Required scopes:**
  - `https://www.googleapis.com/auth/spreadsheets`
  - `https://www.googleapis.com/auth/drive.file`
- **Domain-wide delegation:** Required if impersonating workspace users

---

## 3. Google Sheets Integration

### 3.1 Lead Report Sheet

**Purpose:** Daily report of newly activated leads, delivered to sales team.

**Columns:**
```
A: Date Activated
B: Company Name
C: Domain
D: Industry
E: Employee Count
F: Lead Score
G: Contact Name
H: Contact Email
I: Contact Title
J: HubSpot Link
K: Source
L: XPS Record ID
```

**Update Schedule:** Daily at 06:00 UTC via scheduled workflow.

**Sheet Variable:** `GOOGLE_SHEETS_SPREADSHEET_ID`

### 3.2 Pipeline Status Sheet

**Purpose:** Live pipeline metrics for ops monitoring.

**Columns:**
```
A: Metric Name
B: Value
C: Last Updated
```

---

## 4. Google Drive Integration

**Purpose:** Store PDF exports of weekly intelligence reports.
**Folder:** Configured via `GOOGLE_DRIVE_FOLDER_ID`
**File naming:** `XPS_Intelligence_Report_YYYY-MM-DD.pdf`

---

## 5. Apps Script Integration

Google Apps Script may be used for:
- Manual activation trigger from Sheets UI
- Formatting and conditional formatting of lead reports
- Email notifications on new activations

Apps Script must call XPS service APIs (not Supabase directly).
API key for Apps Script: stored as Apps Script project property (not in git).

---

## 6. Failure Handling

- If Sheets write fails: log to `api_call_log`, retry 3x, then alert
- If Drive upload fails: log and skip — non-critical
- Never write partial data to Sheets — use atomic batch updates
