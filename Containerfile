FROM node:20-slim

# Install system dependencies and tools
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    wget \
    gnupg \
    ca-certificates \
    jq \
    vim \
    less \
    unzip \
    zip \
    openssh-client \
    python3 \
    python3-pip \
    build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Git Credential Manager
RUN curl -L https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb -o /tmp/gcm.deb && \
    dpkg -i /tmp/gcm.deb && \
    rm /tmp/gcm.deb

# Claude Code CLI (npm is already included in node:20-slim)
RUN npm install -g @anthropic-ai/claude-code

# Create a non-root user
RUN useradd -m -s /bin/bash claude
USER claude

WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]
