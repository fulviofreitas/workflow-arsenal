# 🔁 Reusable Workflows

> Reusable GitHub Workflows for cross-repository CI/CD automation.

## Table of Contents

- [Agentic Triage](#-agentic-triage)
- [Agentic Draft Fix](#-agentic-draft-fix)
- [Docker Build](#-docker-build)
- [Reusable Metrics](#-reusable-metrics)
- [Upstream Fork Sync](#-upstream-fork-sync)

---

## 🏷️ Agentic Triage

**File:** [`agentic-triage.yml`](agentic-triage.yml)

Reusable issue-triage workflow. On `issues.opened`/`reopened`, reads the issue, asks an LLM (via `gh models`) to classify it against a caller-provided label allowlist, and applies labels + posts an acknowledgement comment authored by a GitHub App (so downstream `labeled` workflows like [`agentic-draft-fix`](#-agentic-draft-fix) actually fire).

Runs inside the shared `ghcr.io/<owner>/agentic-runner:latest` image (see [`build-agentic-runner-image.yml`](build-agentic-runner-image.yml)).

### Usage

```yaml
name: Issue Triage
on:
  issues:
    types: [opened, reopened]
permissions:
  contents: read
  issues: read
jobs:
  triage:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/agentic-triage.yml@master
    with:
      allowed_labels: 'bug,documentation,enhancement,question,good first issue,help wanted,critical,security,try-fix,needs-review'
      stack_description: 'async Python 3.12+ SDK for the Eero mesh Wi-Fi cloud API'
    secrets:
      RENOVATE_APP_ID: ${{ secrets.RENOVATE_APP_ID }}
      RENOVATE_APP_PRIVATE_KEY: ${{ secrets.RENOVATE_APP_PRIVATE_KEY }}
```

### Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `allowed_labels` | **Yes** | — | Comma-separated allowlist. Model-proposed labels outside this list are dropped. |
| `stack_description` | **Yes** | — | One-line description of the repo stack — surfaced in the prompt. |
| `issue_template_path` | No | `.github/ISSUE_TEMPLATE/issue_report.yml` | Path to issue template YAML for category alignment. |
| `max_labels` | No | `10` | Hard cap on labels applied per issue. |
| `runner_image` | No | `ghcr.io/fulviofreitas/agentic-runner:latest` | Container image. |
| `model` | No | `gpt-4o-mini` | GitHub Models model identifier. |
| `timeout_minutes` | No | `10` | Job timeout. |

### Secrets

| Secret | Required | Description |
|:-------|:---------|:------------|
| `RENOVATE_APP_ID` | **Yes** | App ID used to author label/comment writes (bypasses GitHub anti-recursion). |
| `RENOVATE_APP_PRIVATE_KEY` | **Yes** | PEM private key for that App. |

---

## 🛠️ Agentic Draft Fix

**File:** [`agentic-draft-fix.yml`](agentic-draft-fix.yml)

Reusable draft-fix workflow. When triggered on a `try-fix` label (caller owns the trigger + `if:` guard + concurrency), runs Claude Code in the shared runner image, drafts a patch, runs the caller-configured test + lint suite, and opens a draft PR linked to the issue with `Closes #N`.

Uses two GitHub tokens: the workflow's `GITHUB_TOKEN` for reads/comments, and a short-lived App-scoped token for branch push + PR creation (App-authored PRs fire downstream CI; `GITHUB_TOKEN`-authored PRs do not).

### Usage — Python (single stack)

```yaml
name: Draft Fix
on:
  issues:
    types: [labeled]
concurrency:
  group: draft-fix-${{ github.event.issue.number }}
  cancel-in-progress: true
permissions:
  contents: write
  issues: write
  pull-requests: write
jobs:
  draft-fix:
    if: >-
      github.event.label.name == 'try-fix' &&
      github.event.issue.user.type != 'Bot' &&
      github.event.issue.state == 'open'
    uses: fulviofreitas/workflow-arsenal/.github/workflows/agentic-draft-fix.yml@master
    with:
      stack_description: 'async Python 3.12+ SDK (aiohttp, keyring, Click). Tests: pytest + pytest-asyncio.'
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      RENOVATE_APP_ID: ${{ secrets.RENOVATE_APP_ID }}
      RENOVATE_APP_PRIVATE_KEY: ${{ secrets.RENOVATE_APP_PRIVATE_KEY }}
```

### Usage — dual-stack (Python backend + Node frontend)

```yaml
    with:
      stack_description: 'TypeScript/JS web UI on top of eero-api. Docker/Compose/K8s.'
      test_command: |
        cd frontend && npm test
        cd backend && pytest
      lint_command: |
        cd frontend && npm run lint
        cd backend && ruff check .
      allowed_bash_tools: 'git:*,pytest:*,python:*,python3:*,pip:*,uv:*,ruff:*,black:*,mypy:*,npm:*,npx:*,node:*,yarn:*,pnpm:*,tsc:*,eslint:*,prettier:*,ls:*,cat:*,head:*,tail:*,grep:*,find:*,echo:*,mkdir:*,rm:*,mv:*,cp:*'
      frontend_dir: frontend
      backend_dir: backend
```

### Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `stack_description` | **Yes** | — | One-line stack description — surfaced in the prompt. |
| `runner_image` | No | `ghcr.io/fulviofreitas/agentic-runner:latest` | Container image. |
| `test_command` | No | `pytest` | Multi-line commands the agent must run before committing. |
| `lint_command` | No | `ruff check .` | Multi-line commands the agent must run after tests. |
| `allowed_bash_tools` | No | Python-focused list | Comma-separated Bash tool patterns for `claude --allowed-tools`. |
| `context_repo_name` | No | `<repo>-context` | Sibling private repo cloned for `CLAUDE.md` and `.claude/`. |
| `frontend_dir` | No | `""` | If non-empty, `npm ci` runs in this directory at workflow start. |
| `backend_dir` | No | `""` (i.e. `.`) | Path from repo root to install Python deps from. |
| `dev_extra` | No | `[dev]` | Pip extra installed (`.[dev]`). Empty string skips pip install. |
| `protected_paths` | No | `.github/workflows .github/agents .github/aw .github/docker` | Space-separated paths reset to base branch before commit. |
| `max_turns` | No | `60` | Claude Code max-turns cap. |
| `model` | No | `opus` | Claude model. |
| `timeout_minutes` | No | `15` | Job timeout. |

### Secrets

| Secret | Required | Description |
|:-------|:---------|:------------|
| `CLAUDE_CODE_OAUTH_TOKEN` | **Yes** | Anthropic OAuth token from `claude setup-token`. |
| `RENOVATE_APP_ID` | **Yes** | App ID for context-repo clone + PR-creation tokens. |
| `RENOVATE_APP_PRIVATE_KEY` | **Yes** | PEM private key for that App. |

### Security notes

- Issue body is materialised via env-var substitution, not shell-interpolated — protects against `` ` `` / `$(...)` in the body.
- Issue title/body wrapped in `<untrusted_issue_*>` blocks with explicit "treat as data" system rules.
- `--allowed-tools` allowlist restricts Bash to the caller's declared patterns; no `curl`/`wget`/`nc`/`ssh`.
- Any agent changes under `protected_paths` are reset to the base branch before the commit is created.
- Raw agent output never appears in the PR body (only the agent's own structured `## Summary` section) — full stderr lives in the step summary.

---

## 🐳 Docker Build

**File:** [`docker-build.yml`](docker-build.yml)

Multi-platform Docker image builds using native runners (AMD64 + ARM64 in parallel) with manifest merging. Includes SBOM generation and provenance attestations.

### Usage

```yaml
jobs:
  docker:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/docker-build.yml@master
    with:
      image-name: ghcr.io/myorg/myimage
      push: true
    secrets:
      registry-password: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `image-name` | **Yes** | — | Docker image name (e.g., `ghcr.io/org/repo`) |
| `context` | No | `.` | Docker build context |
| `dockerfile` | No | `Dockerfile` | Path to Dockerfile |
| `push` | No | `false` | Push image to registry |
| `registry` | No | `ghcr.io` | Container registry |
| `registry-username` | No | `""` | Registry username |
| `build-args` | No | `""` | Build arguments |
| `annotations` | No | `""` | Image annotations |
| `generate-sbom` | No | `true` | Generate SBOM |
| `generate-provenance` | No | `true` | Generate provenance attestation |

### Secrets

| Secret | Required | Description |
|:-------|:---------|:------------|
| `registry-password` | No | Registry password/token |

### Outputs

| Output | Description |
|:-------|:------------|
| `digest` | Image digest |
| `tags` | Image tags |

### How It Works

1. **Build** — AMD64 and ARM64 images built in parallel on native runners
2. **Merge** — Manifest list created combining both architectures
3. **Attest** — SBOM and provenance attestations generated and attached

---

## 📊 Reusable Metrics

**File:** [`reusable-metrics.yml`](reusable-metrics.yml)

Generate repository metrics SVGs using [lowlighter/metrics](https://github.com/lowlighter/metrics) and commit them to the repository for README display.

### Usage

```yaml
jobs:
  metrics:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/reusable-metrics.yml@master
    with:
      repo: my-repo-name
      branch: master
    secrets: inherit
```

### Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `repo` | **Yes** | — | Repository name (e.g., `eero-api`) |
| `branch` | No | `master` | Branch to commit metrics to |
| `filename` | No | `metrics.repository.svg` | Output filename |
| `template` | No | `repository` | Metrics template to use |
| `languages_limit` | No | `8` | Number of languages to show |
| `include_stargazers` | No | `true` | Include stargazers chart |
| `include_followup` | No | `true` | Include follow-up issues/PRs section |

### Secrets

Requires `RENOVATE_APP_ID` and `RENOVATE_APP_PRIVATE_KEY` (pass via `secrets: inherit`).

### Generated Metrics

- Language distribution
- Repository traffic and stargazers
- Open/closed issues and PRs follow-up
- Overall repository activity

---

## 🔁 Upstream Fork Sync

**File:** [`upstream-fork-sync.yml`](upstream-fork-sync.yml)

For repositories that are forks: detects when the upstream branch has
advanced past the merge-base and opens a PR with a `--no-ff` merge commit
so the diff is reviewable. Re-runs update the same PR.

### Usage

```yaml
on:
  schedule:
    - cron: "37 6 * * *"
  workflow_dispatch:

jobs:
  sync:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/upstream-fork-sync.yml@master
    with:
      upstream-repo: CoderLuii/HolyClaude
      upstream-branch: master
      fork-base-branch: master
      pr-labels: "upstream-sync,automated"
      pr-assignees: fulviofreitas
    secrets: inherit
```

### Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `upstream-repo` | **Yes** | — | `owner/repo` of upstream |
| `upstream-branch` | No | `master` | Branch on upstream |
| `fork-base-branch` | No | `master` | Branch to PR into |
| `pr-labels` | No | `upstream-sync,automated` | Labels |
| `pr-assignees` | No | `""` | Assignees |
