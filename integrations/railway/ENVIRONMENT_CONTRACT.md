# XPS Intelligence — Railway Environment Contract

**Version:** 1.0.0
**Status:** AUTHORITATIVE

---

## 1. Overview

Railway is the runtime plane for all XPS Intelligence services. This document defines the environment structure, service topology, and variable contract for Railway deployments.

---

## 2. Railway Project Structure

**Project Name:** xps-intelligence

### Services

| Service | Repo | Port | Health Check |
|---------|------|------|-------------|
| xps-system-api | xps-intelligence-system | 3000 | GET /health |
| xps-source-adapter-runner | xps-source-adapters | 3001 | GET /health |
| xps-workspace-bridge | xps-workspace-bridge | 3002 | GET /health |

### Environments

| Environment | Purpose | Auto-Deploy Branch |
|-------------|---------|-------------------|
| `production` | Live production traffic | `main` |
| `staging` | Pre-production validation | `staging` |

---

## 3. Environment Variable Requirements

All services must have these base variables:

```
XPS_ENV=production|staging
XPS_LOG_LEVEL=info|debug|error
XPS_ACTIVATION_SCORE_THRESHOLD=70
```

Per-service additional variables are defined in the credential matrix in:
`docs/05-security/UNIFIED_CREDENTIAL_AND_ENVIRONMENT_STRATEGY.md`

---

## 4. Deployment Contract

- All services MUST expose a `GET /health` endpoint returning HTTP 200 with `{"status":"ok","service":"<name>","version":"<semver>"}`.
- Deployments MUST pass health check within 60 seconds or be rolled back automatically.
- Production deployments MUST only trigger from the `main` branch via GitHub Actions.
- No direct Railway CLI deploys to production — all production deploys go through CI.
- Staging deployments may be triggered manually or via CI on the `staging` branch.

---

## 5. Rollback Procedure

1. Identify failing deploy in Railway dashboard.
2. Navigate to the deployment history.
3. Select the last known-good deployment.
4. Click "Redeploy" on the last known-good deployment.
5. Verify health check passes.
6. Document the rollback in a GitHub issue with label `ci-cd`.

---

## 6. Resource Limits (Baseline)

| Service | Memory | CPU | Replicas |
|---------|--------|-----|---------|
| xps-system-api | 512MB | 0.5 vCPU | 1 (production: 2) |
| xps-source-adapter-runner | 256MB | 0.25 vCPU | 1 |
| xps-workspace-bridge | 256MB | 0.25 vCPU | 1 |

Scale as required based on data volume. All services must handle graceful shutdown on SIGTERM.
