FROM node:22-slim

# Install OpenClaw
RUN npm install -g openclaw

# Create workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose OpenClaw port
EXPOSE 18789

# Start OpenClaw
CMD ["/start.sh"]
