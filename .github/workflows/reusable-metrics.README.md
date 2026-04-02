# 📊 Reusable Metrics (Reusable Workflow)

Generate repository metrics SVGs using [lowlighter/metrics](https://github.com/lowlighter/metrics) and commit them to the repository for README display.

## Usage

```yaml
jobs:
  metrics:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/reusable-metrics.yml@master
    with:
      repo: my-repo-name
      branch: master
    secrets: inherit
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `repo` | **Yes** | — | Repository name (e.g., `eero-api`) |
| `branch` | No | `master` | Branch to commit metrics to |
| `filename` | No | `metrics.repository.svg` | Output filename |
| `template` | No | `repository` | Metrics template to use |
| `languages_limit` | No | `8` | Number of languages to show |
| `include_stargazers` | No | `true` | Include stargazers chart |
| `include_followup` | No | `true` | Include follow-up issues/PRs section |

## Secrets

Requires `RENOVATE_APP_ID` and `RENOVATE_APP_PRIVATE_KEY` (pass via `secrets: inherit`).

## Generated Metrics

- Language distribution
- Repository traffic and stargazers
- Open/closed issues and PRs follow-up
- Overall repository activity
