# Local Agent Framework

## Purpose
Define the parallel local agent system used to build and maintain the XPS platform faster and more safely.

## Core idea
Use multiple specialized agents with disjoint ownership and a single control-plane memory system.

## Agent lanes

### 1. Control agent
Owns:
- contracts
- memory
- checklists
- CI validation

### 2. Runtime agent
Owns:
- auth
- role pages
- API contracts
- worker runtime

### 3. Intelligence agent
Owns:
- taxonomy
- seed registries
- benchmark packs
- distillate index

### 4. Distillation agent
Owns:
- normalization
- validation
- confidence scoring
- packaging

### 5. Editor/admin agent
Owns:
- `open-lovable` donor extraction
- admin control plane
- editor center screen
- preview and sandbox UX

### 6. Validation agent
Owns:
- smoke tests
- benchmark suites
- regression checks
- deployment verification

## Coordination rules
- all agents rehydrate from platform memory first
- no agent should redefine platform law
- write scopes should remain as separate as possible
- final integration happens in the host/runtime and control-plane repos
