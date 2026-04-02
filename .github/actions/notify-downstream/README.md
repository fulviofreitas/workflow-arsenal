# 🔔 Notify Downstream

Notify downstream repositories about dependency updates via `repository_dispatch`. Uses GitHub App authentication for cross-repo token generation.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/notify-downstream@master
  with:
    app-id: ${{ secrets.APP_ID }}
    app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
    target-repo: "my-downstream-repo"
    package: "my-package"
    version: "1.2.3"
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `app-id` | **Yes** | — | GitHub App ID |
| `app-private-key` | **Yes** | — | GitHub App private key |
| `target-repo` | **Yes** | — | Target repository name (without owner) |
| `owner` | No | `fulviofreitas` | Repository owner |
| `package` | **Yes** | — | PyPI package name |
| `version` | **Yes** | — | Version that was released |
| `event-type` | No | `""` | Custom repository dispatch event type |

## Outputs

| Output | Description |
|:-------|:------------|
| `token` | Generated GitHub App token |

## How It Works

1. Generates a scoped GitHub App token for the target repo
2. Sends a `repository_dispatch` event with package/version payload
3. The downstream repo can listen for `<package>-dependency-update-available` events
