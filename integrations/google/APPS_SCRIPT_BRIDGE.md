# Google Apps Script Bridge

> This document describes the Google Apps Script integration that bridges XPS Intelligence data with Google Sheets for reporting, dashboards, and manual review workflows.

---

## 1. Overview

The Apps Script Bridge provides:

- **Live data pulls** from Supabase into Google Sheets
- **Activation triggers** — mark records in Sheets to queue for HubSpot activation
- **Pipeline status dashboards** — view enrichment and activation metrics
- **Manual review queue** — flag records for human review before activation

---

## 2. Architecture

```
Google Sheets (UI)
      │
      ▼ (Apps Script triggers)
Apps Script Project
      │
      ├── fetch_companies()  ──▶  Supabase REST API  ──▶  company_records table
      ├── fetch_activations() ──▶  Supabase REST API  ──▶  lead_activation_records table
      └── trigger_activation() ──▶  XPS Activation Service (Railway)
```

The Apps Script makes authenticated calls to:
- **Supabase REST API** — to read normalized company records
- **XPS Activation REST endpoint** — to trigger on-demand lead activation

---

## 3. Setup Instructions

### 3.1 Create the Google Sheets Workbook

1. Create a new Google Sheet named `XPS Intelligence Dashboard`
2. Create the following sheets (tabs):
   - `Companies` — enriched company records
   - `Activations` — lead activation history
   - `Review Queue` — records flagged for manual review
   - `Config` — Apps Script configuration values

### 3.2 Open the Apps Script Editor

1. In the Google Sheet, go to **Extensions** → **Apps Script**
2. Rename the project to `XPS Intelligence Bridge`

### 3.3 Configure the Config Sheet

In the `Config` tab, set up the following key-value pairs in columns A and B:

| Key (Column A) | Value (Column B) |
|----------------|-----------------|
| `SUPABASE_URL` | `https://xxxx.supabase.co` |
| `SUPABASE_ANON_KEY` | `eyJ...` (anon key — read-only) |
| `XPS_ACTIVATION_URL` | `https://your-railway-service.up.railway.app/activate` |
| `XPS_API_KEY` | Internal API key for Railway activation service |
| `COMPANY_LIMIT` | `500` |
| `MIN_ENRICHMENT_SCORE` | `60` |

> ⚠️ Use the **anon key** (not service role key) for Supabase access from Apps Script.

### 3.4 Add the Apps Script Code

In the Apps Script editor, replace the default `Code.gs` content with the following:

```javascript
// XPS Intelligence — Google Apps Script Bridge
// Version: 1.0.0

function getConfig() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Config');
  const data = sheet.getDataRange().getValues();
  const config = {};
  data.forEach(([key, value]) => {
    if (key) config[key] = value;
  });
  return config;
}

function fetchCompanies() {
  const config = getConfig();
  const url = `${config.SUPABASE_URL}/rest/v1/company_records` +
    `?select=company_id,name,domain,industry,employee_range,hq_country,enrichment_score,updated_at` +
    `&is_suppressed=eq.false` +
    `&enrichment_score=gte.${config.MIN_ENRICHMENT_SCORE || 60}` +
    `&order=enrichment_score.desc` +
    `&limit=${config.COMPANY_LIMIT || 500}`;

  const response = UrlFetchApp.fetch(url, {
    headers: {
      'apikey': config.SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${config.SUPABASE_ANON_KEY}`,
      'Content-Type': 'application/json',
    },
    muteHttpExceptions: true,
  });

  if (response.getResponseCode() !== 200) {
    SpreadsheetApp.getUi().alert(`Error fetching companies: ${response.getContentText()}`);
    return;
  }

  const companies = JSON.parse(response.getContentText());
  writeCompaniesToSheet(companies);
}

function writeCompaniesToSheet(companies) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Companies');
  sheet.clearContents();

  const headers = [
    'Company ID', 'Name', 'Domain', 'Industry',
    'Employee Range', 'HQ Country', 'Enrichment Score', 'Last Updated',
    'Activate?'
  ];
  sheet.appendRow(headers);

  companies.forEach(c => {
    sheet.appendRow([
      c.company_id, c.name, c.domain, c.industry || '',
      c.employee_range || '', c.hq_country || '',
      c.enrichment_score || 0, c.updated_at,
      '' // Activate? column — user fills in TRUE to queue for activation
    ]);
  });

  // Format header row
  const headerRange = sheet.getRange(1, 1, 1, headers.length);
  headerRange.setFontWeight('bold');
  headerRange.setBackground('#1a73e8');
  headerRange.setFontColor('#ffffff');

  SpreadsheetApp.getActiveSpreadsheet().toast(`Loaded ${companies.length} companies.`, 'XPS Intelligence');
}

function activateMarkedRecords() {
  const config = getConfig();
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Companies');
  const data = sheet.getDataRange().getValues();

  const toActivate = [];
  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const activateFlag = row[8]; // Column I — "Activate?"
    if (activateFlag === true || activateFlag === 'TRUE' || activateFlag === 'true') {
      toActivate.push({ company_id: row[0], name: row[1] });
    }
  }

  if (toActivate.length === 0) {
    SpreadsheetApp.getUi().alert('No records marked for activation. Set "Activate?" to TRUE for rows you want to activate.');
    return;
  }

  const confirmed = SpreadsheetApp.getUi().alert(
    `Activate ${toActivate.length} record(s)?`,
    `The following companies will be pushed to HubSpot:\n${toActivate.map(c => c.name).join('\n')}`,
    SpreadsheetApp.getUi().ButtonSet.YES_NO
  );

  if (confirmed !== SpreadsheetApp.getUi().Button.YES) return;

  let successCount = 0;
  let failCount = 0;

  toActivate.forEach(record => {
    try {
      const response = UrlFetchApp.fetch(`${config.XPS_ACTIVATION_URL}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': config.XPS_API_KEY,
        },
        payload: JSON.stringify({ company_id: record.company_id }),
        muteHttpExceptions: true,
      });

      if (response.getResponseCode() === 200 || response.getResponseCode() === 201) {
        successCount++;
      } else {
        failCount++;
        Logger.log(`Failed to activate ${record.company_id}: ${response.getContentText()}`);
      }
    } catch (e) {
      failCount++;
      Logger.log(`Error activating ${record.company_id}: ${e.message}`);
    }
  });

  SpreadsheetApp.getActiveSpreadsheet().toast(
    `Activation complete: ${successCount} succeeded, ${failCount} failed.`,
    'XPS Intelligence'
  );
}

function addMenu() {
  SpreadsheetApp.getUi()
    .createMenu('XPS Intelligence')
    .addItem('Refresh Companies', 'fetchCompanies')
    .addItem('Activate Marked Records', 'activateMarkedRecords')
    .addToUi();
}

// Auto-run on open
function onOpen() {
  addMenu();
}
```

### 3.5 Set Triggers

1. In Apps Script editor, go to **Triggers** (clock icon)
2. Add trigger: `onOpen` → From spreadsheet → On open
3. Optionally add: `fetchCompanies` → Time-driven → Daily (for auto-refresh)

---

## 4. Usage

1. Open the Google Sheet
2. Click **XPS Intelligence** → **Refresh Companies** to load latest records
3. In the `Companies` sheet, set the **Activate?** column to `TRUE` for rows you want pushed to HubSpot
4. Click **XPS Intelligence** → **Activate Marked Records**
5. Confirm the activation dialog

---

## 5. Security Notes

- Only the `SUPABASE_ANON_KEY` (read-only) is used from Apps Script
- The `XPS_API_KEY` for the activation endpoint should be a separate, scoped token
- Never store the `SUPABASE_SERVICE_ROLE_KEY` in the Config sheet
- The Config sheet should be protected — restrict editing to named users only
