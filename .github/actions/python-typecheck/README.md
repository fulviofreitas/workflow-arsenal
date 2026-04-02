# 🔍 Python Typecheck

Run [mypy](https://mypy-lang.org/) type checking on Python code.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/python-typecheck@master
  with:
    src-path: "src/"
    fail-on-error: true
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `src-path` | No | `src/` | Source directory to type check |
| `strict` | No | `false` | Enable strict mode |
| `ignore-missing-imports` | No | `true` | Ignore missing imports |
| `fail-on-error` | No | `false` | Fail the job on type errors |
| `working-directory` | No | `.` | Working directory |
| `use-uv` | No | `true` | Use `uv` to run mypy |

## Outputs

| Output | Description |
|:-------|:------------|
| `passed` | Whether type check passed |
| `error-count` | Number of type errors found |

## Behavior

- When `fail-on-error` is `false` (default), type errors are reported as warnings but don't fail the job
- When `strict` is enabled, mypy runs with `--strict` flag for maximum type safety
