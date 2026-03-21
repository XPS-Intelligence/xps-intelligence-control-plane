# XPS Intelligence — Service Template Manifest

**Version:** 1.0.0
**Purpose:** Required structure and behavior for any XPS Intelligence service.

---

## Required Service Structure (TypeScript/Node.js)

```
service-name/
├── src/
│   ├── index.ts           # Entry point
│   ├── routes/            # API route handlers
│   ├── services/          # Business logic
│   ├── models/            # Data models and schema validators
│   ├── lib/               # Shared utilities (logger, db client, etc.)
│   └── types/             # TypeScript type definitions
├── tests/
│   ├── unit/
│   └── integration/
├── .env.example
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

---

## Required Behaviors

### Health Check Endpoint
Every service MUST expose:
```
GET /health
→ 200 { "status": "ok", "service": "<name>", "version": "<semver>" }
```

### Structured Logging
Every service MUST use JSON logging with fields:
- `level`: info|warn|error|debug
- `service`: service name
- `function`: calling function name
- `request_id`: request identifier (if applicable)
- `message`: human-readable message
- `timestamp`: ISO 8601

### Environment Validation
At startup, every service MUST validate all required environment variables and FAIL FAST if any are missing:

```typescript
const required = ['SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY', 'XPS_ENV'];
for (const key of required) {
  if (!process.env[key]) {
    throw new Error(`FATAL: Missing required environment variable: ${key}`);
  }
}
```

### Graceful Shutdown
Handle SIGTERM:
```typescript
process.on('SIGTERM', async () => {
  logger.info({ message: 'SIGTERM received, shutting down gracefully' });
  await server.close();
  await db.disconnect();
  process.exit(0);
});
```

---

## Schema Validation

All incoming request bodies must be validated against schemas before processing.
Use AJV or equivalent for JSON schema validation.
Return HTTP 422 with structured error body on validation failure.
