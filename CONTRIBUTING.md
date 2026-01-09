# Contributing

Thanks for your interest in improving this project.

## What to Expect

- Be respectful and constructive.
- Keep changes focused and easy to review.

## Development

Requirements:
- Podman

Build the image:
```bash
podman build --platform=linux/arm64 -t claude-code:arm64 .
```

Run the container:
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

## Pull Requests

- Describe the problem and your approach.
- Update documentation when behavior changes.
- Keep formatting consistent with existing files.
