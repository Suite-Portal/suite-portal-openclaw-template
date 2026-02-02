FROM node:22-slim

# Install git and other dependencies in one layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install OpenClaw (cache this layer - only rebuilds if OpenClaw version changes)
RUN npm install -g openclaw@latest --omit=dev

# Create workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Copy file sync script
COPY sync-files.js /sync-files.js

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose OpenClaw port
EXPOSE 18789

# Start OpenClaw
CMD ["/start.sh"]
