# XPS Intelligence — GitHub Project and Automation Spec

**Version:** 1.0.0
**Status:** AUTHORITATIVE

---

## 1. Project Name

**XPS Intelligence Revenue OS — Build Board**

---

## 2. Project Views

### 2.1 Control Plane Build
- **Purpose:** Track all control-plane deliverables and gate completions.
- **Type:** Board
- **Filter:** `label:control-plane`
- **Columns:** Backlog | In Progress | In Review | Done | Blocked

### 2.2 Monday MVP
- **Purpose:** Track all tasks required for Monday MVP launch.
- **Type:** Table + Board
- **Filter:** `milestone:monday-mvp`
- **Columns:** Priority | Status | Assignee | Repo | Milestone | Due Date

### 2.3 Source Onboarding
- **Purpose:** Track source adapter development and data source registration.
- **Type:** Board
- **Filter:** `label:source-adapter`
- **Columns:** Registered | In Development | Testing | Live | Suppressed

### 2.4 Integrations
- **Purpose:** Track all platform integration implementation status.
- **Type:** Table
- **Filter:** `label:integration`
- **Columns:** Platform | Status | Owner | Repo | Spec File | Tested

### 2.5 Launch Blockers
- **Purpose:** Surface P0 issues that block launch.
- **Type:** Board
- **Filter:** `label:launch-blocker`
- **Columns:** Open | Investigating | Fix In Progress | Fixed | Won't Fix

### 2.6 Production Readiness
- **Purpose:** Gate checklist tracking for each launch gate.
- **Type:** Table
- **Filter:** `label:production-readiness`
- **Columns:** Gate | Item | Status | Verified By | Date Verified

---

## 3. Project Fields

| Field | Type | Values |
|-------|------|--------|
| Status | Single select | Backlog, In Progress, In Review, Done, Blocked, Won't Fix |
| Priority | Single select | P0 (Critical), P1 (High), P2 (Medium), P3 (Low) |
| Phase | Single select | Phase 0: Control Plane, Phase 1: System, Phase 2: Sources, Phase 3: Workspace, Phase 4: Analytics, Phase 5: Copilots |
| Repo | Single select | control-plane, system, source-adapters, workspace-bridge, analytics, copilots |
| Gate | Single select | Gate 0, Gate 1, Gate 2, Gate 3, Gate 4, Gate 5, Gate 6 |
| Sprint | Iteration | 1-week sprints |
| Estimate | Number | Story points (1, 2, 3, 5, 8, 13) |

---

## 4. Labels

| Label | Color | Description |
|-------|-------|-------------|
| `control-plane` | `#0052CC` | Control plane repository tasks |
| `schema-change` | `#E11D48` | Changes to schema files — requires architectural review |
| `integration` | `#7C3AED` | Platform integration work |
| `source-adapter` | `#059669` | Source adapter development |
| `launch-blocker` | `#DC2626` | Blocks launch — P0 priority |
| `production-readiness` | `#D97706` | Production readiness gate items |
| `security` | `#DC2626` | Security-related issues |
| `documentation` | `#6B7280` | Documentation updates |
| `bug` | `#EF4444` | Bug reports |
| `architecture-change` | `#2563EB` | Architecture-level changes |
| `monday-mvp` | `#F59E0B` | Required for Monday MVP |
| `needs-review` | `#8B5CF6` | Requires review before proceeding |
| `data-contract` | `#06B6D4` | Changes to data contracts or schemas |
| `ci-cd` | `#10B981` | CI/CD pipeline changes |

---

## 5. Milestones

| Milestone | Description | Target |
|-----------|-------------|--------|
| `control-plane-v1` | Control plane repository complete (Gate 0) | Sprint 1 |
| `infrastructure-ready` | Infrastructure provisioned (Gate 1) | Sprint 1 |
| `pipeline-ready` | Core pipeline functional (Gate 2) | Sprint 2 |
| `sources-connected` | 3+ sources connected (Gate 3) | Sprint 3 |
| `monday-mvp` | Monday MVP criteria met | Sprint 3 |
| `workspace-live` | Workspace bridge live (Gate 4) | Sprint 4 |
| `analytics-operational` | Analytics live (Gate 5) | Sprint 4 |
| `production-launch` | Full production launch (Gate 6) | Sprint 5 |

---

## 6. Automation Rules

### 6.1 Auto-assign to Board
- When issue is opened with `label:control-plane` → add to Control Plane Build view
- When issue is opened with `label:launch-blocker` → add to Launch Blockers view, set Priority = P0
- When issue is opened with `label:source-adapter` → add to Source Onboarding view
- When PR is opened → add to correct repo view based on head branch prefix

### 6.2 Status Transitions
- When PR is opened → set linked issues to "In Review"
- When PR is merged → set linked issues to "Done"
- When PR is closed without merge → set linked issues back to "In Progress"
- When issue is labeled `launch-blocker` → set Status to "Blocked"

### 6.3 Triage
- New issues without labels → auto-add to triage queue
- Issues open > 7 days without assignee → add `needs-review` label

---

## 7. Issue Template to Project Mapping

| Template | Labels Applied | Project View |
|----------|---------------|-------------|
| new-source.yml | `source-adapter`, `integration` | Source Onboarding |
| bug.yml | `bug` | Launch Blockers (if P0), else current sprint board |
| architecture-change.yml | `architecture-change`, `schema-change` | Control Plane Build |
| integration-request.yml | `integration`, `needs-review` | Integrations |

---

## 8. Swimlanes

| Swimlane | Filter | Use |
|----------|--------|-----|
| P0 Critical | `priority:P0` | Always visible at top |
| This Sprint | `sprint:current` | Current sprint work |
| Launch Blockers | `label:launch-blocker` | Blocker tracking |
| Needs Review | `label:needs-review` | Pending review items |
