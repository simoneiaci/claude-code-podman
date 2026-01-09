FROM node:20-slim

# Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Create a non-root user
RUN useradd -m -s /bin/bash claude
USER claude

WORKDIR /workspace
ENTRYPOINT ["claude"]
