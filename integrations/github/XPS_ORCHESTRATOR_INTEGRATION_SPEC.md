# XPS Orchestrator — GitHub App Integration Spec

**Version:** 1.0.0
**Status:** PLANNED (Extensibility Spec Only)
**Owner:** XPS Intelligence Engineering

> **NOTE:** This document defines the safe extensibility points and integration assumptions for a future XPS Orchestrator GitHub App. It does NOT contain or imply any actual app credentials, webhook endpoints, or fabricated API routes. Secrets must never be committed to this repository.

---

## 1. Purpose

The XPS Orchestrator GitHub App is intended to provide governance, automation, and cross-repo orchestration capabilities for the XPS Intelligence repository ecosystem. This spec documents the intended integration points so that when the app is configured, it can plug in with minimal friction.

---

## 2. Assumed Permissions Model

The XPS Orchestrator App would require the following minimum GitHub permissions:

| Permission | Level | Justification |
|------------|-------|---------------|
| Contents | Read | Read repo files for governance checks |
| Issues | Write | Create and update issues for pipeline events |
| Pull Requests | Read | Monitor PR status for deployment gates |
| Actions | Read | Monitor workflow run status |
| Checks | Write | Create check runs for custom validations |
| Deployments | Write | Create deployment records for Railway deploy events |
| Metadata | Read | Required for all GitHub Apps |

---

## 3. Safe Extensibility Points

### 3.1 Workflow Dispatch Trigger (via GitHub Actions)
The safest integration pattern is triggering GitHub Actions workflows via `workflow_dispatch`. No external credentials are required in app code — the app uses its installation token to call the GitHub API:

```
POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches
```

This pattern is approved for:
- Triggering `repo-health.yml` checks
- Triggering `template-validation.yml` on new repo creation
- Triggering deployment workflows on approved activation

### 3.2 Issue Creation for Pipeline Events
The app can create GitHub Issues to surface pipeline events that require human review:

```
POST /repos/{owner}/{repo}/issues
```

Approved use cases:
- Source adapter failure requiring manual investigation
- HubSpot sync failure after 3 retries
- Schema validation failure on ingest
- Activation gate exception for manual review

### 3.3 Status Checks on PRs
The app can post status checks to block or allow PRs:

```
POST /repos/{owner}/{repo}/statuses/{sha}
```

Approved use cases:
- Schema change validation
- Integration contract compliance check
- Launch checklist gate verification

### 3.4 Deployment Events
The app can create deployment records to track Railway deployments:

```
POST /repos/{owner}/{repo}/deployments
POST /repos/{owner}/{repo}/deployments/{deployment_id}/statuses
```

---

## 4. What the App Must NOT Do

- MUST NOT have direct write access to Supabase databases.
- MUST NOT store or proxy API keys for HubSpot, OpenAI, or other services.
- MUST NOT trigger unreviewed production data writes.
- MUST NOT create or merge PRs without human approval.
- MUST NOT modify schema files directly — schema changes require human PR review.
- MUST NOT bypass branch protection rules.

---

## 5. Webhook Events to Subscribe

| Event | Purpose |
|-------|---------|
| `push` | Trigger validation on commits to main |
| `pull_request` | Run schema and contract checks |
| `workflow_run` | Monitor CI outcomes |
| `deployment_status` | Sync Railway deployment status |
| `issues` | Respond to pipeline event issues |

---

## 6. Future Integration Points

When the XPS Orchestrator App is formally configured:

1. Add the app's installation webhook URL to each repo's webhook settings.
2. Store the app's private key in GitHub Organization Secrets as `XPS_ORCHESTRATOR_APP_PRIVATE_KEY`.
3. Store the app's client ID in GitHub Organization Variables as `XPS_ORCHESTRATOR_APP_ID`.
4. Reference these in workflow files using `${{ secrets.XPS_ORCHESTRATOR_APP_PRIVATE_KEY }}` pattern.
5. Do not hardcode these values anywhere in source code.
