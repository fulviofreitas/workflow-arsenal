# 🧹 Python Lint

Run Python code quality checks with black, isort, and ruff. Supports `uv` for fast tool execution.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/python-lint@master
  with:
    src-path: "src/"
    tests-path: "tests/"
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `src-path` | No | `src/` | Source directory to lint |
| `tests-path` | No | `tests/` | Tests directory to lint |
| `check-black` | No | `true` | Run black formatter check |
| `check-isort` | No | `true` | Run isort import sorting check |
| `check-ruff` | No | `true` | Run ruff linter |
| `working-directory` | No | `.` | Working directory |
| `use-uv` | No | `true` | Use `uvx` to run tools |

## Outputs

| Output | Description |
|:-------|:------------|
| `black-passed` | Whether black check passed |
| `isort-passed` | Whether isort check passed |
| `ruff-passed` | Whether ruff check passed |
| `all-passed` | Whether all checks passed |

## Tools

- **Black** — Code formatting
- **isort** — Import sorting
- **Ruff** — Fast Python linting
