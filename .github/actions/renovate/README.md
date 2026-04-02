# 🔄 Renovate

Run [Renovate](https://github.com/renovatebot/renovate) with GitHub App authentication and repository caching for faster subsequent runs.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/renovate@master
  with:
    app-id: ${{ secrets.RENOVATE_APP_ID }}
    app-private-key: ${{ secrets.RENOVATE_APP_PRIVATE_KEY }}
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `app-id` | **Yes** | — | GitHub App ID |
| `app-private-key` | **Yes** | — | GitHub App private key |
| `config-file` | No | `.github/renovate.json5` | Path to Renovate config |
| `dry-run` | No | `false` | Dry-run mode (no PRs created) |
| `log-level` | No | `info` | Log level (`debug`, `info`, `warn`) |
| `reset-cache` | No | `false` | Reset repository cache |

## Outputs

| Output | Description |
|:-------|:------------|
| `token` | Generated GitHub App token |

## Features

- Repository cache persisted across runs via artifacts (7-day retention)
- Cache restoration from previous successful runs
- Dry-run mode for testing configuration changes
- Cache reset option when needed
