# Contributing

Thanks for your interest in improving this project.

This project follows the Contributor Covenant Code of Conduct.

## What to Expect

- Be respectful and constructive.
- Keep changes focused and easy to review.

## Ways to Contribute

- Report bugs or request features via GitHub issues.
- Improve documentation or examples.
- Submit pull requests for fixes or enhancements.

## Before You Submit

- Check existing issues and pull requests to avoid duplication.
- Keep commits scoped to a single change.
- Update documentation when behavior or usage changes.

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
- Call out any manual test steps you ran.
- Keep formatting consistent with existing files.
