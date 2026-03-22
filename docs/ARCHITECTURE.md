# Control Plane Architecture

## Purpose
`xps-intelligence-control-plane` is the governance and template authority for the XPS Intelligence ecosystem.

## Governs
- repository roles
- architecture contracts
- workflow contracts
- environment conventions
- bootstrap order
- checklist gates
- reflection loops
- reusable templates
- integration contracts

## Governed repositories
- `xps-intelligence-system`
- `xps-intel`
- `xps-distallation-system`
- `xps-ui`
- `xps-source-adapter-template`
- `xps-google-workspace-bridge`
- `xps-analytics-bi`
- `xps-employee-copilots`

## Control layers
### Truth layer
- `C:\XPS\AGENTS.md`
- `docs/07-prompts/PLATFORM_MEMORY.md`

### Navigation layer
- `docs/01-architecture/MASTER_INDEX.md`

### Architecture layer
- `docs/01-architecture/XPS_MASTER_BLUEPRINT.md`
- `docs/01-architecture/SYSTEM_CONTRACT.md`
- `docs/01-architecture/REPOSITORY_MAP.md`

### Execution layer
- `docs/03-checklists/MASTER_BUILD_CHECKLIST.md`
- `docs/03-checklists/REFLECTION_LOOP.md`
- `bootstrap/repo-bootstrap-order.md`

## Rule
Downstream repositories implement this repo's contracts rather than redefining platform law independently.
