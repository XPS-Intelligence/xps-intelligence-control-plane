# XPS Intelligence — Unified Credential and Environment Strategy

**Version:** 1.0.0
**Status:** AUTHORITATIVE
**Owner:** XPS Intelligence Engineering

---

## 1. Principle

One credential naming contract governs all environments and all repos. No secret is duplicated without documented reason. Public and private variables are explicitly separated.

---

## 2. Environment Tiers

| Tier | Purpose | Owner |
|------|---------|-------|
| `local` | Developer workstation | Individual developer |
| `ci` | GitHub Actions CI/CD | GitHub Secrets |
| `staging` | Railway staging environment | Railway Environments |
| `production` | Railway production environment | Railway Environments |

---

## 3. Canonical Environment Variable Naming Convention

Format: `{SERVICE}_{CATEGORY}_{NAME}`

Examples:
- `SUPABASE_DB_URL`
- `HUBSPOT_API_KEY`
- `OPENAI_API_KEY`
- `RAILWAY_DEPLOY_TOKEN`
- `GOOGLE_SERVICE_ACCOUNT_JSON`

Rules:
- All uppercase.
- Use underscores as separators.
- Service prefix from the approved list below.
- No abbreviations not in the approved list.

### Approved Service Prefixes

| Prefix | Service |
|--------|---------|
| `SUPABASE_` | Supabase |
| `HUBSPOT_` | HubSpot |
| `OPENAI_` | OpenAI |
| `GROQ_` | Groq |
| `OLLAMA_` | Ollama |
| `ELEVENLABS_` | ElevenLabs |
| `RAILWAY_` | Railway |
| `GOOGLE_` | Google Workspace / GCP |
| `GITHUB_` | GitHub (Actions built-ins only) |
| `XPS_` | XPS internal application config |

---

## 4. Full Secret Registry

### 4.1 Supabase

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `SUPABASE_URL` | Public | Supabase project | All services + CI | On project change |
| `SUPABASE_ANON_KEY` | Public (limited) | Supabase project | Client-side services only | On key rotation |
| `SUPABASE_SERVICE_ROLE_KEY` | **PRIVATE** | Supabase project | Server-side services only | 90 days |
| `SUPABASE_DB_URL` | **PRIVATE** | Supabase project | Migrations, analytics | 90 days |
| `SUPABASE_JWT_SECRET` | **PRIVATE** | Supabase project | JWT validation services | On rotation |

### 4.2 HubSpot

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `HUBSPOT_API_KEY` | **PRIVATE** | HubSpot account | xps-intelligence-system | 90 days |
| `HUBSPOT_PORTAL_ID` | Public | HubSpot account | All CRM services | On portal change |
| `HUBSPOT_SANDBOX_API_KEY` | **PRIVATE** | HubSpot sandbox | CI testing only | 90 days |

### 4.3 OpenAI

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `OPENAI_API_KEY` | **PRIVATE** | OpenAI account | xps-intelligence-system enrichment | 90 days |
| `OPENAI_ORG_ID` | Public | OpenAI account | All OpenAI consumers | On org change |

### 4.4 Groq

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `GROQ_API_KEY` | **PRIVATE** | Groq account | xps-intelligence-system enrichment | 90 days |

### 4.5 ElevenLabs

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `ELEVENLABS_API_KEY` | **PRIVATE** | ElevenLabs account | xps-employee-copilots | 90 days |

### 4.6 Ollama

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `OLLAMA_BASE_URL` | Public | Self-hosted | Local dev + Ollama Cloud | On instance change |
| `OLLAMA_CLOUD_API_KEY` | **PRIVATE** | Ollama Cloud | xps-intelligence-system | 90 days |

### 4.7 Google Workspace

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `GOOGLE_SERVICE_ACCOUNT_JSON` | **PRIVATE** | GCP project | xps-workspace-bridge | 180 days |
| `GOOGLE_SHEETS_SPREADSHEET_ID` | Public | Google Sheets | xps-workspace-bridge | On sheet change |
| `GOOGLE_DRIVE_FOLDER_ID` | Public | Google Drive | xps-workspace-bridge | On folder change |

### 4.8 Railway

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `RAILWAY_DEPLOY_TOKEN` | **PRIVATE** | Railway account | GitHub Actions CI | 180 days |

### 4.9 XPS Application

| Variable | Type | Owner | Destination | Rotation |
|----------|------|-------|-------------|----------|
| `XPS_ENV` | Public | XPS Engineering | All services | N/A |
| `XPS_LOG_LEVEL` | Public | XPS Engineering | All services | N/A |
| `XPS_ACTIVATION_SCORE_THRESHOLD` | Public | XPS Engineering | xps-intelligence-system | On policy change |
| `XPS_SUPPRESSION_LIST_URL` | Public | XPS Engineering | xps-intelligence-system | On change |

---

## 5. Environment Variable Matrix by Repo

| Variable | control-plane | system | source-adapters | workspace-bridge | analytics | copilots |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|
| `SUPABASE_URL` | CI only | ✅ | ✅ | ✅ | ✅ | ✅ |
| `SUPABASE_SERVICE_ROLE_KEY` | CI only | ✅ | ✅ | — | ✅ | — |
| `SUPABASE_ANON_KEY` | — | — | — | — | — | ✅ |
| `HUBSPOT_API_KEY` | — | ✅ | — | — | — | — |
| `OPENAI_API_KEY` | — | ✅ | — | — | — | ✅ |
| `GROQ_API_KEY` | — | ✅ | — | — | — | — |
| `ELEVENLABS_API_KEY` | — | — | — | — | — | ✅ |
| `GOOGLE_SERVICE_ACCOUNT_JSON` | — | — | — | ✅ | — | — |
| `RAILWAY_DEPLOY_TOKEN` | CI only | CI only | CI only | CI only | CI only | CI only |

---

## 6. Local Development

Developers use a `.env.local` file (never committed to git) for local development. A `.env.example` file in each repo documents required variables with non-secret placeholder values.

`.env.local` rules:
- Never committed to git (`.gitignore` enforced)
- Populated from Railway staging environment or team 1Password vault
- Must be refreshed when credentials rotate

---

## 7. CI/CD (GitHub Actions)

- All secrets stored in GitHub repository or organization secrets.
- Secrets injected as environment variables in workflow steps.
- Never echoed or logged in workflow output.
- Least privilege: each workflow only receives the secrets it needs.

---

## 8. Rotation Policy

| Rotation Interval | Secret Types |
|-------------------|-------------|
| 90 days | API keys (OpenAI, HubSpot, Groq, Supabase service role) |
| 180 days | Service account JSON (Google), Railway deploy tokens |
| On incident | All secrets immediately if exposure suspected |
| On person offboarding | All secrets accessible by offboarding individual |

Rotation process:
1. Generate new credential in the issuing service.
2. Update Railway environment variable.
3. Update GitHub Secret.
4. Update team 1Password vault.
5. Verify deployment health post-rotation.
6. Revoke old credential.
7. Log rotation event in CREDENTIAL_ROTATION_LOG.md.
