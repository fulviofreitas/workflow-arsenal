# 🎯 Workflow Arsenal

> A centralized collection of 16 production-ready, reusable GitHub Actions and 2 reusable Workflows for CI/CD automation.

[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/fulviofreitas/workflow-arsenal)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📦 Actions

| Action | Description | Docs |
|:-------|:------------|:-----|
| **auto-merge** | Automatically merge approved PRs with required labels | [README](.github/actions/auto-merge/README.md) |
| **commitlint** | Validate commit messages against conventional commit format | [README](.github/actions/commitlint/README.md) |
| **docker-build** | Build and push multi-platform Docker images | [README](.github/actions/docker-build/README.md) |
| **frontend-check** | Run frontend type checking and linting | [README](.github/actions/frontend-check/README.md) |
| **frontend-test** | Run frontend tests with coverage | [README](.github/actions/frontend-test/README.md) |
| **notify-downstream** | Notify downstream repositories about dependency updates | [README](.github/actions/notify-downstream/README.md) |
| **pypi-publish** | Build and publish Python packages to PyPI using Trusted Publishing | [README](.github/actions/pypi-publish/README.md) |
| **python-lint** | Run Python linting with black, isort, and ruff | [README](.github/actions/python-lint/README.md) |
| **python-test** | Run Python tests with pytest and coverage | [README](.github/actions/python-test/README.md) |
| **python-typecheck** | Run mypy type checking on Python code | [README](.github/actions/python-typecheck/README.md) |
| **renovate** | Run Renovate with GitHub App authentication and caching | [README](.github/actions/renovate/README.md) |
| **security-semgrep** | Run Semgrep security scan (Python, JavaScript, TypeScript) | [README](.github/actions/security-semgrep/README.md) |
| **semantic-release** | Run semantic-release for automated versioning | [README](.github/actions/semantic-release/README.md) |
| **setup-python** | Set up Python with uv or pip, including dependency caching | [README](.github/actions/setup-python/README.md) |
| **wait-for-pypi** | Wait for a package version to become available on PyPI | [README](.github/actions/wait-for-pypi/README.md) |
| **wiki-sync** | Sync wiki directory to GitHub Wiki | [README](.github/actions/wiki-sync/README.md) |

## 🔁 Reusable Workflows

| Workflow | Description | Docs |
|:---------|:------------|:-----|
| **docker-build** | Multi-platform Docker builds with native runners and manifest merging | [README](.github/workflows/README.md#-docker-build) |
| **reusable-metrics** | Generate repository metrics SVGs using lowlighter/metrics | [README](.github/workflows/README.md#-reusable-metrics) |

---

## 🚀 Quick Start

**Reference an action:**

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/<action-name>@master
```

**Call a reusable workflow:**

```yaml
jobs:
  build:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/<workflow>.yml@master
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

## 🔒 Versioning & Pinning

| Method | Example |
|:-------|:--------|
| Pin to `@master` (recommended) | `fulviofreitas/workflow-arsenal/.github/actions/setup-python@master` |
| Pin to commit SHA (most secure) | `fulviofreitas/workflow-arsenal/.github/actions/setup-python@abc1234` |
| Pin to release tag (when available) | `fulviofreitas/workflow-arsenal/.github/actions/setup-python@v1` |

---

## 🤝 Contributing

1. Fork this repository
2. Create a feature branch (`git checkout -b feat/my-action`)
3. Add or modify actions under `.github/actions/<action-name>/`
4. Include a `README.md` in the action directory with inputs, outputs, and usage
5. Test your changes in a workflow
6. Submit a pull request

**Guidelines:**
- All actions must be composite actions (`using: "composite"`)
- Each action directory must include a `README.md`
- Follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages

---

## 📄 License

[MIT](LICENSE) — use freely in your own projects.
