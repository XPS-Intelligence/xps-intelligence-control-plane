# MCP and Connectivity Strategy

## Purpose
Define how MCP-style tooling, Docker, GitHub, and Railway should stay aligned for the XPS platform.

## Principles
- GitHub is the source of truth.
- Docker is the local validation environment.
- Railway is the deployment environment.
- MCP/tool connectivity must be explicit, governed, and repeatable.
- Local and remote systems should share the same contracts and environment names.

## Required connectivity surfaces
- GitHub repository access
- GitHub Actions CI/CD
- Docker local runtime
- Railway runtime and deploy metadata
- browser automation tooling
- LLM provider routing
- scraper/provider connectors

## MCP baseline
The platform should maintain a single registry of enabled tool providers and their purpose:
- browser automation
- file and repo operations
- deployment control
- design/editor context
- issue/project workflows
- connector health

## Rule
Add new MCP/tool connectivity through governed config, not ad hoc local-only setup.
