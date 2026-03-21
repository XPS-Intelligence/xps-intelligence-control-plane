# Railway Environment Contract

> This document defines all environment variables required by XPS Intelligence services running on Railway. All variables must be set before deployment. No secrets should be committed to source code.

---

## How to Set Variables

1. Go to the [Railway Dashboard](https://railway.app)
2. Select your project → **Variables** tab
3. Add each variable listed below for the appropriate service
4. Click **Deploy** to apply changes

For local development, create a `.env` file at the project root (add `.env` to `.gitignore`).

---

## Global Variables (All Services)

| Variable | Required | Example Value | Description |
|----------|----------|---------------|-------------|
| `RAILWAY_ENVIRONMENT` | ✅ | `production` | Current environment. One of: `production`, `staging`, `development` |
| `LOG_LEVEL` | ❌ | `info` | Logging verbosity. One of: `debug`, `info`, `warn`, `error` |
| `LOG_FORMAT` | ❌ | `json` | Log format. One of: `json`, `text` |

---

## Supabase Variables

| Variable | Required | Example Value | Description |
|----------|----------|---------------|-------------|
| `SUPABASE_URL` | ✅ | `https://xxxx.supabase.co` | Supabase project URL. Found in Project Settings → API |
| `SUPABASE_ANON_KEY` | ✅ | `eyJ...` | Supabase anonymous/public key. **Read-only access only.** |
| `SUPABASE_SERVICE_ROLE_KEY` | ✅ | `eyJ...` | Supabase service role key. **Full access — never expose client-side.** |

> ⚠️ `SUPABASE_SERVICE_ROLE_KEY` bypasses Row-Level Security. Use only in server-side worker services.

---

## HubSpot Variables

| Variable | Required | Example Value | Description |
|----------|----------|---------------|-------------|
| `HUBSPOT_API_KEY` | ✅ | `pat-na1-...` | HubSpot Private App access token |
| `HUBSPOT_PORTAL_ID` | ✅ | `12345678` | HubSpot portal (account) ID |
| `HUBSPOT_SANDBOX_MODE` | ❌ | `false` | Set to `true` to force all writes to sandbox portal |

---

## OpenAI / AI Variables

| Variable | Required | Example Value | Description |
|----------|----------|---------------|-------------|
| `OPENAI_API_KEY` | ✅ | `sk-...` | OpenAI API key for enrichment and classification |
| `OPENAI_MODEL` | ❌ | `gpt-4o-mini` | OpenAI model to use. Defaults to `gpt-4o-mini` |
| `OPENAI_MAX_TOKENS` | ❌ | `500` | Max tokens per enrichment request |

---

## Pipeline Tuning Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `ACTIVATION_SCORE_THRESHOLD` | ❌ | `70` | Minimum activation score (0-100) for a lead to be pushed to HubSpot |
| `ENRICHMENT_BATCH_SIZE` | ❌ | `50` | Number of records processed per enrichment batch |
| `CRAWLER_RATE_LIMIT_RPS` | ❌ | `1` | Requests per second for web crawlers |
| `CRAWLER_REQUEST_TIMEOUT_S` | ❌ | `30` | HTTP request timeout in seconds |
| `DEDUP_WINDOW_HOURS` | ❌ | `24` | Hours to look back when checking for duplicate raw records |
| `MAX_RETRY_COUNT` | ❌ | `3` | Maximum retry attempts for failed pipeline operations |
| `RETRY_BACKOFF_BASE_S` | ❌ | `5` | Base seconds for exponential back-off between retries |

---

## Notification Variables (Optional)

| Variable | Required | Example Value | Description |
|----------|----------|---------------|-------------|
| `SLACK_WEBHOOK_URL` | ❌ | `https://hooks.slack.com/...` | Slack Incoming Webhook for pipeline notifications |
| `ALERT_EMAIL` | ❌ | `ops@xps-intelligence.com` | Email address for critical failure alerts |

---

## GitHub Actions Secrets

The following Railway-specific variables must also be set as GitHub Actions secrets for CI/CD:

| Secret Name | Description |
|-------------|-------------|
| `RAILWAY_TOKEN` | Railway API token for the `railway up` CLI command |
| `SUPABASE_URL` | Same as Railway variable above |
| `SUPABASE_SERVICE_ROLE_KEY` | Same as Railway variable above |
| `HUBSPOT_API_KEY` | Same as Railway variable above |
| `OPENAI_API_KEY` | Same as Railway variable above |

To set GitHub Actions secrets:
1. Go to Repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add each secret listed above

---

## Variable Validation Checklist

Before first deployment, verify:

- [ ] `RAILWAY_ENVIRONMENT` is set to `production` or `staging`
- [ ] `SUPABASE_URL` points to the correct project
- [ ] `SUPABASE_SERVICE_ROLE_KEY` is the **service role** key (not anon key)
- [ ] `HUBSPOT_API_KEY` is a Private App token (not legacy API key)
- [ ] `OPENAI_API_KEY` has sufficient quota for enrichment volume
- [ ] `ACTIVATION_SCORE_THRESHOLD` is set to an appropriate value (default: 70)
- [ ] No variables are set to placeholder values like `YOUR_KEY_HERE`
