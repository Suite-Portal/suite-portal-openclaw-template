#!/bin/bash
set -e

echo "🚀 Starting OpenClaw Agent..."
echo "   Agent ID: ${AGENT_ID}"
echo "   Agent Name: ${AGENT_NAME}"
echo "   Agent Role: ${AGENT_ROLE}"
echo "   Agent Model: ${AGENT_MODEL}"

# Initialize OpenClaw workspace
cd /workspace

# Create IDENTITY.md if agent metadata is provided
if [ -n "$AGENT_NAME" ] && [ -n "$AGENT_ROLE" ]; then
  cat > IDENTITY.md <<EOF
# IDENTITY.md - Who Am I?

- **Name:** ${AGENT_NAME}
- **Role:** ${AGENT_ROLE}
- **Description:** ${AGENT_DESCRIPTION}
- **Model:** ${AGENT_MODEL:-anthropic/claude-sonnet-4-5}
- **Thinking:** ${AGENT_THINKING:-low}
- **Tools:** ${AGENT_TOOLS:-exec,read,write,edit}

---

## About Me

I am ${AGENT_NAME}, a ${AGENT_ROLE} agent running in the Suite Portal agent orchestration system.

${AGENT_DESCRIPTION}

## My Configuration

- **Agent ID:** ${AGENT_ID}
- **Model:** ${AGENT_MODEL:-anthropic/claude-sonnet-4-5}
- **Thinking Level:** ${AGENT_THINKING:-low}
- **Available Tools:** ${AGENT_TOOLS:-exec,read,write,edit}
EOF
  echo "✅ Created IDENTITY.md"
fi

# Create SOUL.md
cat > SOUL.md <<EOF
# SOUL.md - Who You Are

You are **${AGENT_NAME}**, a ${AGENT_ROLE}.

${AGENT_DESCRIPTION}

## Core Principles

- Be helpful and professional
- Focus on your role as ${AGENT_ROLE}
- Use your tools effectively
- Document important information in memory files

## Your Tools

You have access to: ${AGENT_TOOLS:-exec,read,write,edit}

Use them to accomplish your tasks efficiently.
EOF
echo "✅ Created SOUL.md"

# Create memory directory
mkdir -p memory
echo "✅ Created memory directory"

# Start OpenClaw gateway in foreground mode (no systemd)
echo "🎯 Starting OpenClaw gateway..."
exec openclaw gateway --port 18789 --bind lan --verbose
