# Suite Portal OpenClaw Template

Railway template for deploying OpenClaw agents.

## Environment Variables

Configure your agent using these environment variables:

### Required
- `AGENT_ID` - Unique identifier for this agent
- `AGENT_NAME` - Display name for the agent
- `AGENT_MODEL` - AI model to use (e.g., `anthropic/claude-sonnet-4-5`)

### Optional
- `AGENT_ROLE` - Role description (e.g., "Testing Agent")
- `AGENT_DESCRIPTION` - Longer description of agent's purpose
- `AGENT_THINKING` - Thinking level: `low`, `medium`, `high` (default: `low`)
- `AGENT_TOOLS` - Comma-separated list of tools (default: `exec,read,write,edit`)
- `ANTHROPIC_API_KEY` - API key for Anthropic models
- `OPENAI_API_KEY` - API key for OpenAI models

### Advanced
- `OPENCLAW_GATEWAY_URL` - URL of OpenClaw gateway (if using remote gateway)
- `OPENCLAW_GATEWAY_TOKEN` - Authentication token for gateway
- `PORT` - Port to listen on (default: 3000)

## Deployment

This template is designed to be deployed via Railway CLI or API.

### Via Railway CLI

```bash
railway service create --source github.com/Suite-Portal/suite-portal-openclaw-template
railway variables set AGENT_NAME="My Agent"
railway variables set AGENT_MODEL="anthropic/claude-sonnet-4-5"
railway up
```

### Via Railway API

Services are created programmatically via the Suite Portal Agents UI.

## Architecture

- **Base Image:** `node:20-slim`
- **OpenClaw:** Installed globally via npm
- **Workspace:** `/workspace`
- **Port:** 3000 (health check + API)
- **Restart Policy:** On failure (max 3 retries)

## Health Check

The agent exposes a health check endpoint at `/health` that Railway uses to monitor service health.

## Logs

View logs via Railway dashboard or CLI:

```bash
railway logs
```

## Development

To test locally:

```bash
docker build -t openclaw-agent .
docker run -e AGENT_NAME="Test" -e AGENT_MODEL="anthropic/claude-sonnet-4-5" openclaw-agent
```
