# XPS Intelligence — Repo Template Manifest

**Version:** 1.0.0
**Purpose:** Required files and structure for any new XPS Intelligence repository.

---

## Required Files

Every XPS Intelligence repository MUST contain:

| File | Description |
|------|-------------|
| `README.md` | Repo purpose, setup instructions, links to control-plane contracts |
| `.env.example` | All required environment variables with placeholder values |
| `.gitignore` | Standard gitignore including `.env.local`, `node_modules`, `dist` |
| `CHANGELOG.md` | Version history |
| `.github/workflows/ci.yml` | CI pipeline (lint, test, build) |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR template |

---

## Required README Sections

1. **Purpose** — What this repo does and its role in the build order.
2. **Build Order Position** — Which phase this repo belongs to.
3. **Depends On** — What upstream repos/systems must be running.
4. **Setup** — How to run locally.
5. **Environment Variables** — Link to `.env.example`.
6. **Deployment** — How to deploy to Railway.
7. **Schema Contracts** — Links to relevant schemas in control-plane.
8. **No-Mock-Data Policy** — Statement of compliance.

---

## CI Requirements

The CI pipeline must validate:
- Linting (ESLint for TS/JS, flake8 for Python)
- Type checking (tsc --noEmit for TypeScript)
- Tests (minimum unit tests for core functions)
- Schema validation against control-plane schemas

---

## No-Mock-Data Compliance Statement

Include in README:

> This repository complies with the XPS Intelligence No-Mock-Data Policy.
> All schemas target real production data structures as defined in
> xps-intelligence-control-plane/schemas/. Demo data is clearly marked
> non-production. No stub services are connected to live endpoints.
