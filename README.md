
🟣 PROCEDURE 2 — CLAUDE CODE (Clean → Setup → Use)

1️⃣ Clean Claude Code environment ONLY

# Remove container (by name)
podman rm -f claude-code 2>/dev/null

# Remove image
podman rmi -f claude-code:arm64 2>/dev/null

# Remove any leftover containers from the image
podman rm -f $(podman ps -aq --filter ancestor=claude-code) 2>/dev/null

# Remove Claude auth/config on host
rm -rf \
  "$HOME/.claude-home" \
  "$HOME/.claude"


⸻

2️⃣ Build Claude Code image

Containerfile (~/claude-code-podman/Containerfile)

FROM node:20-slim

RUN npm install -g @anthropic-ai/claude-code

ENV HOME=/home/claude
RUN mkdir -p /home/claude && chmod 777 /home/claude

WORKDIR /workspace
ENTRYPOINT ["claude"]

Build:

cd ~/claude-code-podman
podman build --platform=linux/arm64 -t claude-code:arm64 .


⸻

3️⃣ Authenticate Claude Code (first run)

mkdir -p "$HOME/.claude-home"

podman run --rm -it \
  --name claude-code \
  --user "$(id -u):$(id -g)" \
  -e HOME=/home/claude \
  -v "$HOME/.claude-home:/home/claude" \
  -v "$HOME/Documents/AI:/workspace" \
  -w /workspace \
  claude-code:arm64

➡️ Follow Claude’s login flow once
➡️ Auth stored in ~/.claude-home

⸻

4️⃣ Daily Claude Code usage (CLI only)

Same command as above:

podman run --rm -it \
  --name claude-code \
  --user "$(id -u):$(id -g)" \
  -e HOME=/home/claude \
  -v "$HOME/.claude-home:/home/claude" \
  -v "$HOME/Documents/AI:/workspace" \
  -w /workspace \
  claude-code:arm64


⸻

5️⃣ Verify

claude whoami


⸻

🧠 Key Principles (same for both)
	•	Explicit HOME → predictable auth
	•	Bind-mounted HOME → persistence
	•	--user $(id -u) → no macOS permission issues
	•	Device auth for Codex → avoids broken localhost OAuth
	•	Named containers → easy lifecycle control

⸻

If you want next:
	•	shared base image
	•	podman-compose
	•	SSH/Git signing
	•	VS Code Dev Containers

You’re now on a rock-solid setup 💪
