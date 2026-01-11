# claude-code-podman

Run the Anthropic Claude Code CLI inside a Podman container with a persistent
host-mounted home directory for authentication.

## Features

- Claude Code CLI
- GitHub CLI (`gh`)
- Git with Git Credential Manager
- Node.js & npm (pre-installed)
- Python 3 & pip
- Development tools: curl, wget, jq, vim, zip/unzip, build-essential
- SSH client
- Persistent authentication

## Requirements

- Podman
- A working Claude Code account

## Build the image

```bash
podman build --platform=linux/arm64 -t localhost/claude-code:arm64 .
```

> **Note:** Podman will automatically pull the base image if not present locally.

## Configure workspace path

Set your workspace directory (customize this to your needs):

```bash
export AI_WORKSPACE_DIR="$HOME/Documents/AI"
```

## First-time authentication

```bash
mkdir -p "$HOME/.claude-home"

podman run --rm -it \
  --name claude-code \
  --user "$(id -u):$(id -g)" \
  -e HOME=/home/claude \
  -v "$HOME/.claude-home:/home/claude" \
  -v "$HOME/.gitconfig:/home/claude/.gitconfig:ro" \
  -v "$HOME/.ssh:/home/claude/.ssh:ro" \
  -v "${AI_WORKSPACE_DIR}:/workspace" \
  -w /workspace \
  localhost/claude-code:arm64 -c "claude login"
```

Follow the device login flow. Credentials are stored in `~/.claude-home`.

> **Note:** Your host `~/.gitconfig` and `~/.ssh` are mounted read-only, so git commands will use your existing git identity and SSH keys for GitHub authentication.

## Daily usage

```bash
podman run --rm -it \
  --name claude-code \
  --user "$(id -u):$(id -g)" \
  --security-opt no-new-privileges \
  --cap-drop=ALL \
  --memory="4g" \
  --cpus="2.0" \
  --pids-limit 100 \
  -e HOME=/home/claude \
  -v "$HOME/.claude-home:/home/claude" \
  -v "$HOME/.gitconfig:/home/claude/.gitconfig:ro" \
  -v "$HOME/.ssh:/home/claude/.ssh:ro" \
  -v "${AI_WORKSPACE_DIR}:/workspace" \
  -w /workspace \
  localhost/claude-code:arm64
```

**Security features:**
- `--security-opt no-new-privileges`: Prevents privilege escalation
- `--cap-drop=ALL`: Drops all Linux capabilities
- `--memory="4g"`: Limits memory usage to 4GB
- `--cpus="2.0"`: Limits CPU usage to 2 cores
- `--pids-limit 100`: Prevents fork bombs by limiting processes

## Verify

```bash
claude whoami
```

## Shell aliases

For quick access, add these to your `.zshrc` or `.bashrc`:

```bash
# First-time authentication
alias claude-code-pod-init='mkdir -p "$HOME/.claude-home" && podman run --rm -it --name claude-code --user "$(id -u):$(id -g)" -e HOME=/home/claude -v "$HOME/.claude-home:/home/claude" -v "$HOME/.gitconfig:/home/claude/.gitconfig:ro" -v "$HOME/.ssh:/home/claude/.ssh:ro" -v "${AI_WORKSPACE_DIR}:/workspace" -w /workspace localhost/claude-code:arm64 -c "claude login"'

# Daily usage
alias claude-code-pod='podman run --rm -it --name claude-code --user "$(id -u):$(id -g)" --security-opt no-new-privileges --cap-drop=ALL --memory="4g" --cpus="2.0" --pids-limit 100 -e HOME=/home/claude -v "$HOME/.claude-home:/home/claude" -v "$HOME/.gitconfig:/home/claude/.gitconfig:ro" -v "$HOME/.ssh:/home/claude/.ssh:ro" -v "${AI_WORKSPACE_DIR}:/workspace" -w /workspace localhost/claude-code:arm64'
```

Then use simply:
```bash
claud-code-pod
```

## Clean up (optional)

```bash
podman rm -f claude-code 2>/dev/null
podman rmi -f localhost/claude-code:arm64 2>/dev/null
podman rm -f $(podman ps -aq --filter ancestor=localhost/claude-code:arm64) 2>/dev/null

rm -rf \
  "$HOME/.claude-home" \
  "$HOME/.claude"
```

## License

MIT. See `LICENSE`.
