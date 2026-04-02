# 📦 PyPI Publish

Build and publish Python packages to PyPI or TestPyPI using [Trusted Publishing (OIDC)](https://docs.pypi.org/trusted-publishers/).

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/pypi-publish@master
  with:
    version: "1.0.0"
```

**TestPyPI:**

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/pypi-publish@master
  with:
    version: "1.0.0"
    repository-url: https://test.pypi.org/legacy/
    skip-existing: true
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `version` | **Yes** | — | Package version being published |
| `python-version` | No | `3.12` | Python version for building |
| `repository-url` | No | `""` | PyPI repository URL (set for TestPyPI) |
| `skip-existing` | No | `false` | Skip upload if version exists |
| `dry-run` | No | `false` | Build but don't upload |
| `attestations` | No | `false` | Generate and upload attestations |

## Outputs

| Output | Description |
|:-------|:------------|
| `published` | Whether the package was published |
| `package-name` | Name of the published package |

## Requirements

- Trusted Publisher configured on PyPI/TestPyPI
- Job must have `id-token: write` permission
- Job should use an environment (e.g., `pypi` or `testpypi`)
