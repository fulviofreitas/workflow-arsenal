# ⚛️ Frontend Check

Run frontend type checking and linting. Supports Svelte, React, and other Node.js-based frontends.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/frontend-check@master
  with:
    working-directory: "frontend/"
    node-version: "20"
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `working-directory` | No | `frontend` | Frontend working directory |
| `node-version` | No | `20` | Node.js version |
| `check-command` | No | `npm run check` | Type check command |
| `lint-command` | No | `npm run lint` | Lint command |
| `run-check` | No | `true` | Run type checking |
| `run-lint` | No | `true` | Run linting |

## Outputs

| Output | Description |
|:-------|:------------|
| `check-passed` | Whether type check passed |
| `lint-passed` | Whether lint passed |
