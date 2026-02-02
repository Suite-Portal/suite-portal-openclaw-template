FROM node:22-slim

# Install git (required for npm to install OpenClaw dependencies)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Install OpenClaw
RUN npm install -g openclaw

# Create workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Create OpenClaw config directory and copy config
RUN mkdir -p /root/.openclaw
COPY openclaw.json /root/.openclaw/openclaw.json

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose OpenClaw port
EXPOSE 18789

# Start OpenClaw
CMD ["/start.sh"]
