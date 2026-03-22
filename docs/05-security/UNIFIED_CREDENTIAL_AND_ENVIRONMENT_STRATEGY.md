# Unified Credential and Environment Strategy

## Rules
- One canonical variable naming convention across repos and platforms.
- Public variables must use NEXT_PUBLIC_ prefix for frontend exposure only.
- Secrets must never be committed.
- GitHub Actions, Railway, and local .env files must use consistent names.

## Required variables
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_ANON_KEY
- SUPABASE_SERVICE_ROLE_KEY
- DATABASE_URL
- REDIS_URL
- GROQ_API_KEY
- OLLAMA_CLOUD_API_KEY
- HUBSPOT_ACCESS_TOKEN
- GITHUB_APP_ID
- GITHUB_APP_INSTALLATION_ID
- GITHUB_APP_PRIVATE_KEY
- NEXT_PUBLIC_API_BASE_URL
- NEXT_PUBLIC_SITE_URL
