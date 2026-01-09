# claude-code-podman

Run the Anthropic Claude Code CLI inside a Podman container with a persistent
host-mounted home directory for authentication.

## Requirements

- Podman
- A working Claude Code account

## Build the image

```bash
podman build --platform=linux/arm64 -t claude-code:arm64 .
```

## First-time authentication

```bash
mkdir -p "$HOME/.claude-home"

podman run --rm -it \
  --name claude-code \
  --user "$(id -u):$(id -g)" \
  -e HOME=/home/claude \
  -v "$HOME/.claude-home:/home/claude" \
  -v "$HOME/Documents/AI:/workspace" \
  -w /workspace \
  claude-code:arm64
```

Follow the device login flow. Credentials are stored in `~/.claude-home`.

## Daily usage

```bash
podman run --rm -it \
  --name claude-code \
  --user "$(id -u):$(id -g)" \
  -e HOME=/home/claude \
  -v "$HOME/.claude-home:/home/claude" \
  -v "$HOME/Documents/AI:/workspace" \
  -w /workspace \
  claude-code:arm64
```

## Verify

```bash
claude whoami
```

## Clean up (optional)

```bash
podman rm -f claude-code 2>/dev/null
podman rmi -f claude-code:arm64 2>/dev/null
podman rm -f $(podman ps -aq --filter ancestor=claude-code) 2>/dev/null

rm -rf \
  "$HOME/.claude-home" \
  "$HOME/.claude"
```

## License

MIT. See `LICENSE`.
