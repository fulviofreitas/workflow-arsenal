# Shared runner image for the agentic-triage and agentic-draft-fix reusable
# workflows in this repo. Consumed via the `container:` key.
#
# Contains ONLY the language toolchains and CLIs. Repo-specific dependencies
# (pip/npm packages from the caller's pyproject.toml or package.json) are
# installed by the reusable workflows at run time so this image stays generic
# across every caller.
#
# Built and pushed to ghcr.io by .github/workflows/build-agentic-runner-image.yml
# on changes to this Dockerfile, on a weekly cron, and on workflow_dispatch.

FROM node:24-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Base OS tooling: git, jq, curl, python, build essentials for native deps.
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg git jq \
      python3 python3-pip python3-venv python3-dev \
      build-essential pkg-config \
    && rm -rf /var/lib/apt/lists/*

# GitHub CLI — needed by the reusable workflows' gh issue/pr/comment steps.
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
      gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Claude Code CLI — the agent runtime that agentic-draft-fix invokes.
RUN npm install -g --no-audit --no-fund @anthropic-ai/claude-code \
    && claude --version

# GitHub Copilot CLI extension — the agent runtime that agentic-triage invokes.
# Installed as a gh extension so `gh copilot` is available on PATH.
# Extension install requires an authenticated gh session at build time; since
# we cannot authenticate here, we defer install to the runtime workflow step.
# The extension is small (~10MB) and installs in a few seconds.

# actions/checkout writes to /github/workspace by default in container jobs.
WORKDIR /github/workspace
