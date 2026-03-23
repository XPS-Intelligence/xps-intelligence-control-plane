# Agent Prompt Library

## Purpose
Collect the reusable prompts that drive the XPS agent system.

## Library contents
- [Master Invocation Prompt](C:\XPS\xps-intelligence-control-plane\docs\07-prompts\MASTER_INVOCATION_PROMPT.md)
- [Master Revealer Prompt](C:\XPS\xps-intelligence-control-plane\docs\07-prompts\MASTER_REVEALER_PROMPT.md)
- [Validation Agent Prompt](C:\XPS\xps-intelligence-control-plane\docs\07-prompts\VALIDATION_AGENT_PROMPT.md)
- [Reflection Agent Prompt](C:\XPS\xps-intelligence-control-plane\docs\07-prompts\REFLECTION_AGENT_PROMPT.md)
- [Documentation Agent Prompt](C:\XPS\xps-intelligence-control-plane\docs\07-prompts\DOCUMENTATION_AGENT_PROMPT.md)
- [Backup Failover Agent Prompt](C:\XPS\xps-intelligence-control-plane\docs\07-prompts\BACKUP_FAILOVER_AGENT_PROMPT.md)
- [Overnight Continuity Prompt](C:\XPS\xps-intelligence-control-plane\docs\07-prompts\OVERNIGHT_CONTINUITY_PROMPT.md)

## Usage rule
Use the smallest prompt that matches the lane.
Do not reuse the master prompt when a specialized agent prompt is enough.

## Prompt design rules
- one job per prompt
- explicit scope
- explicit forbidden actions
- explicit evidence requirements
- explicit handoff conditions
- explicit stall/failover behavior

## Maintenance rule
If a prompt changes behavior, the control plane must update:
- memory
- index
- checklist
- and any affected runbook or coordination contract
