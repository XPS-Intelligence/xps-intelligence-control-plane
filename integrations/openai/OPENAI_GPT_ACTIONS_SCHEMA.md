# XPS Intelligence — OpenAI GPT Actions Schema

**Version:** 1.0.0
**Status:** AUTHORITATIVE

---

## 1. Overview

This document defines the schema contract for all OpenAI GPT Actions that interact with XPS Intelligence services. All actions must conform to these patterns to ensure safety, auditability, and prevention of uncontrolled production writes.

---

## 2. Action Patterns

### 2.1 Read Action Pattern

Read actions retrieve data without modifying system state.

**Contract:**
- HTTP method: `GET`
- Auth: Bearer token (service-specific read-only API key)
- No side effects permitted
- Response: JSON conforming to defined response schema
- Logging: All reads logged to `api_call_log`

**Example OpenAPI fragment:**
```yaml
/api/v1/companies/search:
  get:
    operationId: searchCompanies
    summary: Search normalized companies
    parameters:
      - name: q
        in: query
        required: true
        schema:
          type: string
          maxLength: 200
      - name: limit
        in: query
        schema:
          type: integer
          minimum: 1
          maximum: 50
          default: 10
    responses:
      '200':
        description: Search results
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CompanySearchResponse'
      '422':
        description: Validation error
```

### 2.2 Write Action Pattern

Write actions modify system state and require explicit confirmation.

**Contract:**
- HTTP method: `POST` or `PATCH`
- Auth: Bearer token (write-enabled API key — separate from read key)
- Required body parameters: `confirm: true`, `justification: string`
- All writes MUST be logged to `gpt_action_log` BEFORE execution
- Response includes `action_log_id` for traceability
- Maximum batch size: 10 records per write action

**Example OpenAPI fragment:**
```yaml
/api/v1/leads/activate:
  post:
    operationId: activateLead
    summary: Manually activate a lead for HubSpot sync
    requestBody:
      required: true
      content:
        application/json:
          schema:
            type: object
            required: [company_record_id, confirm, justification]
            properties:
              company_record_id:
                type: string
                format: uuid
              confirm:
                type: boolean
                enum: [true]
                description: Must be explicitly set to true
              justification:
                type: string
                minLength: 10
                maxLength: 500
    responses:
      '202':
        description: Activation queued
        content:
          application/json:
            schema:
              type: object
              properties:
                action_log_id:
                  type: string
                  format: uuid
                activation_id:
                  type: string
                  format: uuid
                status:
                  type: string
                  enum: [QUEUED]
      '403':
        description: Write not confirmed
      '422':
        description: Validation error
```

### 2.3 Command Action Pattern

Command actions trigger pipeline operations or system commands.

**Contract:**
- HTTP method: `POST`
- Auth: Bearer token (command-enabled API key)
- Commands are asynchronous — return job ID immediately
- All commands logged to `gpt_action_log`
- Required: `confirm: true`, `justification: string`, `command: string`
- Allowed commands: defined in service allowlist — no arbitrary commands

**Example OpenAPI fragment:**
```yaml
/api/v1/pipeline/commands:
  post:
    operationId: runPipelineCommand
    summary: Execute an approved pipeline command
    requestBody:
      required: true
      content:
        application/json:
          schema:
            type: object
            required: [command, confirm, justification]
            properties:
              command:
                type: string
                enum:
                  - trigger_normalization_batch
                  - reprocess_failed_records
                  - refresh_source_quality_scores
              confirm:
                type: boolean
                enum: [true]
              justification:
                type: string
                minLength: 10
    responses:
      '202':
        description: Command accepted
        content:
          application/json:
            schema:
              type: object
              properties:
                job_id:
                  type: string
                command:
                  type: string
                status:
                  type: string
                  enum: [ACCEPTED]
```

---

## 3. Safety Gates

The following safety gates MUST be implemented at the API layer before any GPT action reaches business logic:

| Gate | Applies To | Implementation |
|------|-----------|----------------|
| Auth validation | All actions | Bearer token validated against service-specific key |
| Schema validation | All actions | Request validated against OpenAPI schema; 422 on failure |
| Write confirmation | Write + Command | `confirm: true` required; 403 if missing or false |
| Justification required | Write + Command | `justification` >= 10 chars; 422 if missing |
| Batch size limit | Write | Max 10 records per request; 422 if exceeded |
| Command allowlist | Command | Only pre-approved commands accepted; 403 for unknown |
| Rate limiting | All | 60 requests/minute per API key |

---

## 4. Approval Gates

Some operations require human approval before execution:

| Operation | Approval Required | Mechanism |
|-----------|-----------------|-----------|
| Bulk activation (>10 records) | Yes | GitHub Issue approval workflow |
| Schema modification via API | Yes | PR review + merge |
| Suppression list update | Yes | PR review + merge |
| HubSpot property creation | Yes | Manual HubSpot admin action |
| Production environment variable change | Yes | Documented change record |

---

## 5. Audit Logging

Every GPT action MUST produce a log entry in `gpt_action_log` containing:

```json
{
  "id": "<uuid>",
  "action_type": "READ|WRITE|COMMAND",
  "action_endpoint": "/api/v1/...",
  "request_payload": { "...sanitized..." },
  "response_payload": { "...summarized..." },
  "is_write_action": false,
  "confirmed": true,
  "justification": "...",
  "status": "EXECUTED|FAILED|REJECTED",
  "executed_at": "2024-01-01T00:00:00Z",
  "requested_at": "2024-01-01T00:00:00Z"
}
```

Sensitive fields (API keys, passwords) MUST be redacted before logging.

---

## 6. GitHub Workflow Dispatch via GPT

ChatGPT can trigger GitHub Actions via the GitHub REST API using a scoped Personal Access Token or GitHub App installation token stored in the XPS service:

```
POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches
Authorization: Bearer <github_token>
Content-Type: application/json

{
  "ref": "main",
  "inputs": {
    "reason": "Triggered by GPT Action: <justification>"
  }
}
```

**Approved workflow triggers:**
- `repo-health.yml` — Read-only governance check
- `template-validation.yml` — Validation check

**NOT approved for GPT trigger:**
- `pages.yml` — Deploy workflows require human merge
- Any workflow that writes to production

---

## 7. Preventing Uncontrolled Production Writes

| Prevention Mechanism | Description |
|---------------------|-------------|
| Read-only default | GPT actions are read-only by default; write capability must be explicitly requested |
| Separate API keys | Read and write API keys are separate; write key is not included in GPT action config by default |
| Pre-execution logging | All writes logged BEFORE execution; failed log write blocks operation |
| `confirm: true` required | Cannot accidentally trigger write without explicit intent |
| No direct DB access | GPT actions NEVER have direct database credentials |
| Allowlisted commands | No arbitrary code execution; only pre-approved commands |
| Human approval for bulk | Bulk operations always require human approval via GitHub |
