FROM node:20-slim

# Install OpenClaw
RUN npm install -g openclaw@latest

# Create workspace
WORKDIR /workspace

# Copy agent configuration (will be overridden by Railway env vars)
COPY . /workspace/

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => { process.exit(r.statusCode === 200 ? 0 : 1); })"

# Expose port for agent API (if needed)
EXPOSE 3000

# Start OpenClaw agent
CMD ["openclaw", "agent", "start"]
