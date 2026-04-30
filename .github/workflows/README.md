# 🔁 Reusable Workflows

> Reusable GitHub Workflows for cross-repository CI/CD automation.

## Table of Contents

- [Docker Build](#-docker-build)
- [Reusable Metrics](#-reusable-metrics)
- [Manifest Bump](#-manifest-bump)
- [Upstream Fork Sync](#-upstream-fork-sync)

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

## 📦 Manifest Bump

**File:** [`manifest-bump.yml`](manifest-bump.yml)

Open (or update) a PR in a downstream GitOps repo pinning a new container
image tag in a Kubernetes manifest. Idempotent — re-running with the same
tag is a no-op; re-running with a new tag updates the existing PR.

### Usage

```yaml
jobs:
  bump:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/manifest-bump.yml@master
    with:
      downstream-repo: fulviofreitas/ff-k8s
      manifest-path: k8s-homelab/kubernetes/apps/holyclaude/deployment.yaml
      image-name: ghcr.io/fulviofreitas/holyclaude
      image-tag: 1.2.2-fork.3
      pr-title: "chore(holyclaude): bump image to 1.2.2-fork.3"
      pr-body: "Generated after image publish."
      pr-labels: "autoupdate,holyclaude"
      pr-assignees: fulviofreitas
    secrets:
      downstream-token: ${{ secrets.FF_K8S_PR_TOKEN }}
```

### Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `downstream-repo` | **Yes** | — | `owner/repo` of the GitOps repo |
| `downstream-branch` | No | `master` | Branch to base PR on |
| `manifest-path` | **Yes** | — | Path to manifest file |
| `image-name` | **Yes** | — | Image without tag |
| `image-tag` | **Yes** | — | Tag to pin |
| `pr-title` | **Yes** | — | PR title |
| `pr-body` | No | `""` | Markdown body |
| `pr-labels` | No | `autoupdate` | Comma-separated labels |
| `pr-assignees` | No | `""` | Comma-separated assignees |
| `branch-prefix` | No | `bump` | Branch name prefix |

### Secrets

| Secret | Required | Description |
|:-------|:---------|:------------|
| `downstream-token` | **Yes** | PAT with `contents:write` + `pull-requests:write` on `downstream-repo` |

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
