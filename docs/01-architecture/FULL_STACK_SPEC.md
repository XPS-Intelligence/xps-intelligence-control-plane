# XPS Full Stack Specification

## Runtime stack

### Frontend
- Next.js App Router
- TypeScript
- Tailwind CSS
- shadcn/ui patterns where useful
- PWA configuration
- role-aware route protection
- admin/editor surface inspired by `open-lovable`

### API
- Node.js
- TypeScript
- Express
- JWT session tokens
- Zod for request validation
- structured logging

### Worker
- Node.js
- TypeScript
- BullMQ
- Redis-backed job queues
- cron and manual execution paths

### Data
- Railway Postgres as canonical relational store
- Redis as queue/cache backbone
- optional vector store for semantic retrieval when needed

### Auth
- Railway-first app-owned auth
- Postgres-backed users, organizations, roles, autonomy settings, and user profile memory
- bcrypt password hashing
- JWT session tokens
- cookie-backed web session helpers

### Integrations
- HubSpot private app for MVP
- Google Workspace bridge
- Groq for low-latency cloud inference
- Ollama local and optional cloud for cost-controlled 24/7 inhalation
- Firecrawl / Playwright / Steel-style browser tools for approved scanning flows

### Governance and CI/CD
- GitHub repositories and issues
- GitHub Projects
- GitHub Actions
- branch protection and required checks
- Railway deploys from GitHub

## AI stack

### Provider strategy
- primary local reasoning and inhalation: Ollama
- primary low-latency cloud reasoning: Groq
- premium fallback and eval provider: configurable model gateway

### Agent framework
- role agents in `xps-employee-copilots`
- orchestration policy in control plane
- governed tools and memory
- prompt registry with versioning
- evals and reflection loop for regressions

### Recommended model routing
- local extraction and normalization: small fast local models
- cloud summarization and sales recommendation: fast hosted models
- admin strategy and simulation: stronger reasoning models on demand
- embeddings or semantic indexing: only when retrieval quality materially benefits

## Automation stack
- GitHub Actions for CI, CD, nightly validation, dependency hygiene, and governance audits
- BullMQ cron jobs for crawl, validation refresh, score refresh, reminder generation, and drift detection
- Railway service health and deploy automation
- Workspace bridge for calendar/task/email automation

## Environment sample

```env
NODE_ENV=production
NEXT_PUBLIC_SITE_URL=https://app.example.com
NEXT_PUBLIC_API_BASE_URL=https://api.example.com

DATABASE_URL=postgresql://postgres:postgres@postgres:5432/xps
REDIS_URL=redis://redis:6379

JWT_SECRET=change-me
JWT_EXPIRES_IN=12h
BCRYPT_ROUNDS=12

GROQ_API_KEY=
OLLAMA_BASE_URL=http://host.docker.internal:11434
OLLAMA_CLOUD_API_KEY=
MODEL_ROUTER_DEFAULT=groq
MODEL_ROUTER_FALLBACK=ollama

HUBSPOT_ACCESS_TOKEN=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_REDIRECT_URI=

FIRECRAWL_API_KEY=
STEEL_API_KEY=

GITHUB_TOKEN=
GITHUB_APP_ID=
GITHUB_APP_INSTALLATION_ID=
GITHUB_APP_PRIVATE_KEY=

RAILWAY_ENVIRONMENT=production
PORT=3001
LOG_LEVEL=info
```

## Local stack

```yaml
services:
  web:
    build: ./apps/web
    environment:
      NEXT_PUBLIC_API_BASE_URL: http://localhost:4000/api
    ports:
      - "3000:3000"
  api:
    build: ./apps/api
    environment:
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/xps
      REDIS_URL: redis://redis:6379
      JWT_SECRET: local-dev-secret
    ports:
      - "4000:4000"
  worker:
    build: ./apps/worker
    environment:
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/xps
      REDIS_URL: redis://redis:6379
  postgres:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
```

## Benchmark platforms to mirror

### OpenAI-style strengths
- tool-driven agents
- evals and trace review
- strong sandboxing
- model routing and logs

### Anthropic-style strengths
- careful tool boundaries
- strong prompt and system-role discipline
- safer agent behavior

### Google-style strengths
- function calling discipline
- grounded search/tooling
- scalable multimodal orchestration

### What to improve on top of them
- tighter domain-specific taxonomy
- stronger CRM and sales operations coupling
- better admin control plane for non-coders
- more explicit cost guardrails and autonomy levels

## Mandatory open-source and platform choices
- prefer open-source first
- prefer managed platform only when it reduces risk and accelerates shipping
- prefer templates that are Railway-friendly, Docker-friendly, and GitHub-native
