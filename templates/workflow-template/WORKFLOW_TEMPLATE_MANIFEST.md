# XPS Intelligence — Workflow Template Manifest

**Version:** 1.0.0
**Purpose:** Reusable GitHub Actions workflow patterns for XPS repos.

---

## Base CI Template

Every XPS repo CI workflow must include:

1. **Lint step** — Code style validation
2. **Type check step** (TypeScript repos) — `tsc --noEmit`
3. **Test step** — Unit tests with coverage report
4. **Build step** — Production build verification
5. **Schema validation step** — Validate any JSON schema files

Trigger: `push` to `main` and `staging` branches, plus `pull_request` to `main`.

---

## Deploy Template

Railway deployment workflow:

1. Run CI checks (must pass)
2. Deploy to staging on `staging` branch merge
3. Deploy to production on `main` branch merge
4. Run health check post-deploy
5. Rollback if health check fails

---

## Scheduled Maintenance Template

For services with scheduled jobs:

1. Run at configured cron schedule
2. Log job start with run ID
3. Execute job with timeout
4. Log job completion or failure
5. Alert on failure (GitHub Issue or notification)
