# ⏳ Wait for PyPI

Wait for a package version to become available on PyPI. Useful after publishing when downstream workflows need the package to be indexed.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/wait-for-pypi@master
  with:
    package: "my-package"
    version: "1.2.3"
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `package` | **Yes** | — | Package name on PyPI |
| `version` | **Yes** | — | Version to wait for |
| `max-attempts` | No | `20` | Maximum polling attempts |
| `wait-seconds` | No | `15` | Seconds between attempts |
| `fail-on-timeout` | No | `false` | Fail if timeout is reached |

## Outputs

| Output | Description |
|:-------|:------------|
| `available` | Whether the package version is available on PyPI |

## Behavior

- Polls the PyPI JSON API (`https://pypi.org/pypi/<package>/json`) every `wait-seconds`
- Default timeout: 20 attempts x 15s = 5 minutes
- When `fail-on-timeout` is `false`, the step succeeds even on timeout (useful for Renovate triggers)
