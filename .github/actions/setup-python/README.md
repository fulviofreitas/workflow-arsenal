# 🐍 Setup Python

Set up Python with [uv](https://github.com/astral-sh/uv) (preferred) or pip, including dependency caching.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/setup-python@master
  with:
    python-version: "3.12"
    install-dev: true
```

**Without uv (pip fallback):**

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/setup-python@master
  with:
    python-version: "3.12"
    use-uv: false
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `python-version` | No | `3.12` | Python version to install |
| `dependency-file` | No | `pyproject.toml` | Path to dependency file for caching |
| `use-uv` | No | `true` | Use `uv` instead of pip |
| `working-directory` | No | `.` | Working directory |
| `install-dev` | No | `true` | Install dev dependencies |

## Outputs

| Output | Description |
|:-------|:------------|
| `python-version` | Installed Python version |
| `cache-hit` | Whether cache was hit |

## Behavior

- **uv mode** (default): Installs uv via `astral-sh/setup-uv`, then runs `uv sync --extra dev`
- **pip mode**: Uses `actions/setup-python` with pip caching, then runs `pip install -e ".[dev]"`
