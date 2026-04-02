# 🤖 Auto-Merge

Automatically merge approved PRs using [pascalgn/automerge-action](https://github.com/pascalgn/automerge-action). Supports GitHub App authentication for merging PRs that modify workflow files.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/auto-merge@master
  with:
    app-id: ${{ secrets.APP_ID }}
    app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
    merge-labels: "automerge"
    merge-method: "squash"
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `github-token` | No | `""` | GitHub token for merging |
| `app-id` | No | `""` | GitHub App ID (recommended for workflow file PRs) |
| `app-private-key` | No | `""` | GitHub App private key |
| `merge-labels` | No | `automerge` | Labels that trigger merge (comma-separated) |
| `blocking-labels` | No | `wip,do-not-merge` | Labels that block merge (comma-separated) |
| `merge-method` | No | `squash` | Merge method (`merge`, `squash`, `rebase`) |
| `delete-branch` | No | `true` | Delete branch after merge |
| `required-approvals` | No | `1` | Number of required approvals |
| `update-method` | No | `merge` | Method to keep PR up to date with base |

## Outputs

| Output | Description |
|:-------|:------------|
| `merged` | Whether the PR was merged |
| `result` | Merge result status |
| `pr-number` | PR number that was processed |
| `token` | Generated GitHub App token (if app-id was provided) |

## Authentication

Choose one:
1. **GitHub App** (recommended for merging workflow files): provide `app-id` + `app-private-key`
2. **GitHub token** (default, cannot merge workflow files): provide `github-token`
