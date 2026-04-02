# 🎯 Workflow Arsenal

> A centralized collection of 16 production-ready, reusable GitHub Actions and 2 reusable Workflows for CI/CD automation.

[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/fulviofreitas/workflow-arsenal)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📦 Available Actions

| Action | Description |
|:-------|:------------|
| [auto-merge](#-auto-merge) | Automatically merge approved PRs with required labels |
| [commitlint](#-commitlint) | Validate commit messages against conventional commit format |
| [docker-build](#-docker-build) | Build and push multi-platform Docker images |
| [frontend-check](#-frontend-check) | Run frontend type checking and linting |
| [frontend-test](#-frontend-test) | Run frontend tests with coverage |
| [notify-downstream](#-notify-downstream) | Notify downstream repositories about dependency updates |
| [pypi-publish](#-pypi-publish) | Build and publish Python packages to PyPI using Trusted Publishing |
| [python-lint](#-python-lint) | Run Python linting with black, isort, and ruff |
| [python-test](#-python-test) | Run Python tests with pytest and coverage |
| [python-typecheck](#-python-typecheck) | Run mypy type checking on Python code |
| [renovate](#-renovate) | Run Renovate with GitHub App authentication and caching |
| [security-semgrep](#-security-semgrep) | Run Semgrep security scan (Python, JavaScript, TypeScript) |
| [semantic-release](#-semantic-release) | Run semantic-release for automated versioning |
| [setup-python](#-setup-python) | Set up Python with uv or pip, including dependency caching |
| [wait-for-pypi](#-wait-for-pypi) | Wait for a package version to become available on PyPI |
| [wiki-sync](#-wiki-sync) | Sync wiki directory to GitHub Wiki |

## 🔁 Reusable Workflows

| Workflow | Description |
|:---------|:------------|
| [docker-build](#-docker-build-workflow) | Multi-platform Docker builds with native runners and manifest merging |
| [reusable-metrics](#-reusable-metrics-workflow) | Generate repository metrics SVGs using lowlighter/metrics |

---

## 🚀 Quick Start

Reference any action from your workflow using:

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/<action-name>@master
```

**Example — Python CI pipeline:**

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - uses: fulviofreitas/workflow-arsenal/.github/actions/setup-python@master
        with:
          python-version: "3.12"

      - uses: fulviofreitas/workflow-arsenal/.github/actions/python-lint@master
        with:
          src-path: "src/"
          tests-path: "tests/"

      - uses: fulviofreitas/workflow-arsenal/.github/actions/python-test@master
        with:
          test-path: "tests/"
          src-path: "src/mypackage"
```

---

## 📋 Action Catalog

### 🤖 Auto-Merge

Automatically merge approved PRs using [pascalgn/automerge-action](https://github.com/pascalgn/automerge-action). Supports GitHub App authentication for merging PRs that modify workflow files.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `github-token` | No | `""` | GitHub token for merging |
| `app-id` | No | `""` | GitHub App ID (recommended for workflow file PRs) |
| `app-private-key` | No | `""` | GitHub App private key |
| `merge-labels` | No | `automerge` | Labels that trigger merge (comma-separated) |
| `blocking-labels` | No | `wip,do-not-merge` | Labels that block merge (comma-separated) |
| `merge-method` | No | `squash` | Merge method (`merge`, `squash`, `rebase`) |
| `delete-branch` | No | `true` | Delete branch after merge |
| `required-approvals` | No | `1` | Number of required approvals |
| `update-method` | No | `merge` | Method to keep PR up to date with base |

**Outputs:** `merged`, `result`, `pr-number`, `token`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/auto-merge@master
  with:
    app-id: ${{ secrets.APP_ID }}
    app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
    merge-labels: "automerge"
    merge-method: "squash"
```

---

### 📝 Commitlint

Validate commit messages against [Conventional Commits](https://www.conventionalcommits.org/) format.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `node-version` | No | `20` | Node.js version |
| `from-sha` | No | `""` | SHA to start validation from (for PRs) |
| `to-sha` | No | `""` | SHA to end validation at (for PRs) |
| `config-file` | No | `""` | Path to commitlint config file |

**Outputs:** `valid`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/commitlint@master
  with:
    from-sha: ${{ github.event.pull_request.base.sha }}
    to-sha: ${{ github.event.pull_request.head.sha }}
```

---

### 🐳 Docker Build

Build and push multi-platform Docker images with SBOM generation and provenance attestations.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `image-name` | **Yes** | — | Docker image name (e.g., `ghcr.io/org/repo`) |
| `context` | No | `.` | Docker build context |
| `dockerfile` | No | `Dockerfile` | Path to Dockerfile |
| `platforms` | No | `linux/amd64,linux/arm64` | Target platforms |
| `push` | No | `false` | Push image to registry |
| `registry` | No | `ghcr.io` | Container registry |
| `registry-username` | No | `""` | Registry username |
| `registry-password` | No | `""` | Registry password/token |
| `build-args` | No | `""` | Build arguments |
| `labels` | No | `""` | Image labels |
| `annotations` | No | `""` | Image annotations |
| `generate-sbom` | No | `true` | Generate SBOM |
| `generate-provenance` | No | `true` | Generate provenance attestation |

**Outputs:** `digest`, `tags`, `metadata`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/docker-build@master
  with:
    image-name: "ghcr.io/myorg/myimage"
    push: true
    registry-password: ${{ secrets.GITHUB_TOKEN }}
```

---

### ⚛️ Frontend Check

Run frontend type checking and linting. Supports Svelte, React, and other Node.js-based frontends.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `working-directory` | No | `frontend` | Frontend working directory |
| `node-version` | No | `20` | Node.js version |
| `check-command` | No | `npm run check` | Type check command |
| `lint-command` | No | `npm run lint` | Lint command |
| `run-check` | No | `true` | Run type checking |
| `run-lint` | No | `true` | Run linting |

**Outputs:** `check-passed`, `lint-passed`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/frontend-check@master
  with:
    working-directory: "frontend/"
    node-version: "20"
```

---

### 🧪 Frontend Test

Run frontend tests with coverage. Supports Vitest, Jest, and other Node.js test frameworks.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `working-directory` | No | `frontend` | Frontend working directory |
| `node-version` | No | `20` | Node.js version |
| `test-command` | No | `npm run test` | Test command |
| `coverage-command` | No | `npm run test:coverage` | Test with coverage command |
| `run-coverage` | No | `true` | Run tests with coverage |

**Outputs:** `passed`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/frontend-test@master
  with:
    working-directory: "frontend/"
    run-coverage: true
```

---

### 🔔 Notify Downstream

Notify downstream repositories about dependency updates via `repository_dispatch`. Uses GitHub App authentication for cross-repo token generation.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `app-id` | **Yes** | — | GitHub App ID |
| `app-private-key` | **Yes** | — | GitHub App private key |
| `target-repo` | **Yes** | — | Target repository name (without owner) |
| `owner` | No | `fulviofreitas` | Repository owner |
| `package` | **Yes** | — | PyPI package name |
| `version` | **Yes** | — | Version that was released |
| `event-type` | No | `""` | Custom repository dispatch event type |

**Outputs:** `token`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/notify-downstream@master
  with:
    app-id: ${{ secrets.APP_ID }}
    app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
    target-repo: "my-downstream-repo"
    package: "my-package"
    version: "1.2.3"
```

---

### 📦 PyPI Publish

Build and publish Python packages to PyPI or TestPyPI using [Trusted Publishing (OIDC)](https://docs.pypi.org/trusted-publishers/).

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `version` | **Yes** | — | Package version being published |
| `python-version` | No | `3.12` | Python version for building |
| `repository-url` | No | `""` | PyPI repository URL (set for TestPyPI) |
| `skip-existing` | No | `false` | Skip upload if version exists |
| `dry-run` | No | `false` | Build but don't upload |
| `attestations` | No | `false` | Generate and upload attestations |

**Outputs:** `published`, `package-name`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/pypi-publish@master
  with:
    version: "1.0.0"
```

---

### 🧹 Python Lint

Run Python code quality checks with black, isort, and ruff. Supports `uv` for fast tool execution.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `src-path` | No | `src/` | Source directory to lint |
| `tests-path` | No | `tests/` | Tests directory to lint |
| `check-black` | No | `true` | Run black formatter check |
| `check-isort` | No | `true` | Run isort import sorting check |
| `check-ruff` | No | `true` | Run ruff linter |
| `working-directory` | No | `.` | Working directory |
| `use-uv` | No | `true` | Use `uvx` to run tools |

**Outputs:** `black-passed`, `isort-passed`, `ruff-passed`, `all-passed`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/python-lint@master
  with:
    src-path: "src/"
    tests-path: "tests/"
```

---

### 🧪 Python Test

Run Python tests with pytest and coverage. Supports Codecov upload.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `test-path` | No | `tests/` | Path to tests directory |
| `src-path` | No | `src/` | Source path for coverage measurement |
| `coverage-report` | No | `true` | Generate coverage report |
| `coverage-format` | No | `xml` | Coverage report format |
| `test-args` | No | `-v` | Additional pytest arguments |
| `working-directory` | No | `.` | Working directory |
| `use-uv` | No | `true` | Use `uv` to run pytest |
| `upload-coverage` | No | `false` | Upload coverage to Codecov |
| `codecov-token` | No | `""` | Codecov token |

**Outputs:** `passed`, `coverage`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/python-test@master
  with:
    test-path: "tests/"
    src-path: "src/mypackage"
    coverage-report: true
```

---

### 🔍 Python Typecheck

Run [mypy](https://mypy-lang.org/) type checking on Python code.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `src-path` | No | `src/` | Source directory to type check |
| `strict` | No | `false` | Enable strict mode |
| `ignore-missing-imports` | No | `true` | Ignore missing imports |
| `fail-on-error` | No | `false` | Fail the job on type errors |
| `working-directory` | No | `.` | Working directory |
| `use-uv` | No | `true` | Use `uv` to run mypy |

**Outputs:** `passed`, `error-count`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/python-typecheck@master
  with:
    src-path: "src/"
    fail-on-error: true
```

---

### 🔄 Renovate

Run [Renovate](https://github.com/renovatebot/renovate) with GitHub App authentication and repository caching for faster subsequent runs.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `app-id` | **Yes** | — | GitHub App ID |
| `app-private-key` | **Yes** | — | GitHub App private key |
| `config-file` | No | `.github/renovate.json5` | Path to Renovate config |
| `dry-run` | No | `false` | Dry-run mode (no PRs created) |
| `log-level` | No | `info` | Log level (`debug`, `info`, `warn`) |
| `reset-cache` | No | `false` | Reset repository cache |

**Outputs:** `token`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/renovate@master
  with:
    app-id: ${{ secrets.RENOVATE_APP_ID }}
    app-private-key: ${{ secrets.RENOVATE_APP_PRIVATE_KEY }}
```

---

### 🛡️ Security Semgrep

Run [Semgrep](https://semgrep.dev/) security scanning with SARIF output for the GitHub Security tab. Supports Python, JavaScript, TypeScript, and custom rulesets.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `config` | No | `p/python p/security-audit` | Semgrep config (rulesets, space-separated) |
| `target-path` | No | `.` | Path to scan |
| `exclude-paths` | No | `tests/,**/test_*.py,...` | Paths to exclude (comma-separated) |
| `severity` | No | `WARNING` | Minimum severity (`INFO`, `WARNING`, `ERROR`) |
| `fail-on-findings` | No | `true` | Fail the job on findings |
| `upload-sarif` | No | `true` | Upload SARIF to GitHub Security |
| `sarif-output` | No | `semgrep.sarif` | SARIF output filename |
| `working-directory` | No | `.` | Working directory |

**Outputs:** `findings-count`, `passed`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/security-semgrep@master
  with:
    config: "p/python p/security-audit"
    target-path: "src/"
    fail-on-findings: true
```

---

### 🚀 Semantic Release

Run [semantic-release](https://github.com/semantic-release/semantic-release) for automated versioning based on conventional commits.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `github-token` | **Yes** | — | GitHub token for creating releases |
| `node-version` | No | `20` | Node.js version |
| `dry-run` | No | `false` | Dry-run mode |
| `extra-plugins` | No | `""` | Additional plugins (comma-separated) |

**Outputs:** `released`, `version`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/semantic-release@master
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

---

### 🐍 Setup Python

Set up Python with [uv](https://github.com/astral-sh/uv) (preferred) or pip, including dependency caching.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `python-version` | No | `3.12` | Python version to install |
| `dependency-file` | No | `pyproject.toml` | Path to dependency file for caching |
| `use-uv` | No | `true` | Use `uv` instead of pip |
| `working-directory` | No | `.` | Working directory |
| `install-dev` | No | `true` | Install dev dependencies |

**Outputs:** `python-version`, `cache-hit`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/setup-python@master
  with:
    python-version: "3.12"
    install-dev: true
```

---

### ⏳ Wait for PyPI

Wait for a package version to become available on PyPI. Useful after publishing when downstream workflows need the package to be indexed.

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `package` | **Yes** | — | Package name on PyPI |
| `version` | **Yes** | — | Version to wait for |
| `max-attempts` | No | `20` | Maximum polling attempts |
| `wait-seconds` | No | `15` | Seconds between attempts |
| `fail-on-timeout` | No | `false` | Fail if timeout is reached |

**Outputs:** `available`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/wait-for-pypi@master
  with:
    package: "my-package"
    version: "1.2.3"
```

---

### 📚 Wiki Sync

Sync a `wiki/` directory to the GitHub Wiki using [github-wiki-action](https://github.com/Andrew-Chen-Wang/github-wiki-action).

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `wiki-path` | No | `wiki/` | Path to wiki directory |
| `ignore-file` | No | `.gitignore` | File with patterns to ignore |

**Outputs:** `synced`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/wiki-sync@master
  with:
    wiki-path: "wiki/"
```

---

## 🔁 Reusable Workflow Catalog

### 🐳 Docker Build (Workflow)

Multi-platform Docker image builds using native runners (AMD64 + ARM64 in parallel) with manifest merging. Includes SBOM generation and provenance attestations.

**Usage:**

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

**Inputs:**

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

**Secrets:** `registry-password` (optional)

**Outputs:** `digest`, `tags`

---

### 📊 Reusable Metrics (Workflow)

Generate repository metrics SVGs using [lowlighter/metrics](https://github.com/lowlighter/metrics) and commit them to the repository for README display.

**Usage:**

```yaml
jobs:
  metrics:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/reusable-metrics.yml@master
    with:
      repo: my-repo-name
      branch: master
    secrets: inherit
```

**Inputs:**

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `repo` | **Yes** | — | Repository name (e.g., `eero-api`) |
| `branch` | No | `master` | Branch to commit metrics to |
| `filename` | No | `metrics.repository.svg` | Output filename |
| `template` | No | `repository` | Metrics template to use |
| `languages_limit` | No | `8` | Number of languages to show |
| `include_stargazers` | No | `true` | Include stargazers chart |
| `include_followup` | No | `true` | Include follow-up issues/PRs section |

**Secrets:** Requires `RENOVATE_APP_ID` and `RENOVATE_APP_PRIVATE_KEY` (passed via `secrets: inherit`)

---

## 🔒 Versioning & Pinning

### Recommended: Pin to `@master`

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/setup-python@master
```

### More secure: Pin to a specific commit SHA

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/setup-python@abc1234
```

### When available: Pin to a release tag

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/setup-python@v1
```

---

## 🤝 Contributing

1. Fork this repository
2. Create a feature branch (`git checkout -b feat/my-action`)
3. Add or modify actions under `.github/actions/<action-name>/action.yml`
4. Test your changes in a workflow
5. Submit a pull request

**Guidelines:**
- All actions must be composite actions (`using: "composite"`)
- Include clear descriptions, input/output documentation, and usage examples in comments
- Follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages

---

## 📄 License

[MIT](LICENSE) — use freely in your own projects.
