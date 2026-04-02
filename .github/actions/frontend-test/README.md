# 🧪 Frontend Test

Run frontend tests with coverage. Supports Vitest, Jest, and other Node.js test frameworks.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/frontend-test@master
  with:
    working-directory: "frontend/"
    run-coverage: true
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `working-directory` | No | `frontend` | Frontend working directory |
| `node-version` | No | `20` | Node.js version |
| `test-command` | No | `npm run test` | Test command |
| `coverage-command` | No | `npm run test:coverage` | Test with coverage command |
| `run-coverage` | No | `true` | Run tests with coverage |

## Outputs

| Output | Description |
|:-------|:------------|
| `passed` | Whether tests passed |

## Features

- Automatic `npm ci` dependency installation
- Coverage report uploaded as artifact (30-day retention)
