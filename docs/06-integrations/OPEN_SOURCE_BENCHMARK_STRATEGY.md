# Open Source Benchmark Strategy

## Benchmark doctrine
The XPS platform must deliberately combine the strongest public patterns from:
- OpenAI: evals, trace grading, tool-driven agents, prompt and version flywheel
- Anthropic: strict tool boundaries, safer agent behavior, and clearer action discipline
- Google: grounding, orchestration, and multimodal infrastructure discipline

## XPS implementation rule
- `xps-intel` is the domain substrate
- `xps-distallation-system` is the strict truth and validation layer
- `xps-intelligence-system` is the operational runtime
- the admin control plane is the operator cockpit

## Additional provider strategy
- use Ollama for local 24/7 inhalation and nightly refresh
- use Groq for low-latency cloud inference
- keep additional free or low-cost providers behind a pluggable model gateway only when they materially help cost or resilience

## Benchmark enforcement points
- architecture docs
- issue ladders
- checklist gates
- CI validation
- model routing policy
- prompt and trace evals
