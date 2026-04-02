# 🧪 Python Test

Run Python tests with pytest and coverage. Supports Codecov upload.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/python-test@master
  with:
    test-path: "tests/"
    src-path: "src/mypackage"
    coverage-report: true
```

## Inputs

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

## Outputs

| Output | Description |
|:-------|:------------|
| `passed` | Whether tests passed |
| `coverage` | Coverage percentage |
