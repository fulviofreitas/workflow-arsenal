# 🤖 Auto-Merge

Automatically merge PRs using [pascalgn/automerge-action](https://github.com/pascalgn/automerge-action). Supports GitHub App authentication for merging PRs that modify workflow files.

## Conditional Approval Behavior

The action supports skipping approval requirements based on PR labels:

- **PR without `needs-review` label** — merges automatically with **0 approvals** once all required checks pass
- **PR with `needs-review` label** — requires the configured number of approvals (default: 1) before merging

This is controlled by the `review-label` input. Set it to `""` to disable this behavior and always require approvals.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/auto-merge@master
  with:
    app-id: ${{ secrets.APP_ID }}
    app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
    merge-labels: "automerge"
    merge-method: "squash"
```

To always require approvals (disable conditional logic):

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/auto-merge@master
  with:
    app-id: ${{ secrets.APP_ID }}
    app-private-key: ${{ secrets.APP_PRIVATE_KEY }}
    review-label: ""
```

## Dependabot Commit Prefix Fix

By default, the action rewrites Dependabot PR titles from `chore(deps):` to `fix(deps):` before merging. This ensures dependency updates (especially security fixes) trigger a patch release via semantic-release.

- **Enabled by default** — set `fix-dependabot-prefix: "false"` to disable
- Only affects PRs authored by `dependabot[bot]`
- Rewrites both `chore(deps):` and `chore(deps-dev):` prefixes

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
| `required-approvals` | No | `1` | Number of required approvals (when `review-label` is present on PR) |
| `review-label` | No | `needs-review` | Label that requires approval before merge. PRs without this label merge with 0 approvals. Set to `""` to always require approvals. |
| `update-method` | No | `merge` | Method to keep PR up to date with base |
| `fix-dependabot-prefix` | No | `true` | Rewrite Dependabot PR titles from `chore(deps)` to `fix(deps)` for semantic-release compatibility |

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
