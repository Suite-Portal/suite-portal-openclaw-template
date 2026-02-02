# Suite Portal OpenClaw Template

This is the base template for deploying OpenClaw agents in the Suite Portal agent orchestration system.

## Overview

This template creates a containerized OpenClaw agent that:
- Runs OpenClaw gateway
- Configures itself via environment variables
- Auto-generates IDENTITY.md and SOUL.md based on agent config
- Provides isolated workspace for each agent

## Environment Variables

Required:
- `AGENT_ID` - Unique agent identifier (UUID)
- `AGENT_NAME` - Display name for the agent
- `AGENT_ROLE` - Agent's role/purpose
- `AGENT_MODEL` - LLM model to use (default: anthropic/claude-sonnet-4-5)

Optional:
- `AGENT_DESCRIPTION` - Detailed description of the agent's purpose
- `AGENT_THINKING` - Thinking level (low/medium/high, default: low)
- `AGENT_TOOLS` - Comma-separated list of tools (default: exec,read,write,edit)
- `ANTHROPIC_API_KEY` - Anthropic API key for Claude models
- `ORCHESTRATOR_URL` - URL of the Suite Portal orchestrator

## Deployment

This template is designed to be deployed via Railway:

1. Create a new Railway service from this template
2. Set the required environment variables
3. Railway will automatically build and deploy

## Architecture

```
Railway Service
  ↓
Docker Container (this template)
  ↓
OpenClaw Gateway (port 18789)
  ↓
Agent workspace (/workspace)
```

## Local Development

```bash
# Build
docker build -t openclaw-agent .

# Run
docker run -p 18789:18789 \
  -e AGENT_ID=test-agent \
  -e AGENT_NAME="Test Agent" \
  -e AGENT_ROLE="Test Assistant" \
  -e AGENT_MODEL=anthropic/claude-sonnet-4-5 \
  -e ANTHROPIC_API_KEY=your-key \
  openclaw-agent
```

## License

MIT
