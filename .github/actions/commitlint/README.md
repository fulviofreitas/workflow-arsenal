# 📝 Commitlint

Validate commit messages against [Conventional Commits](https://www.conventionalcommits.org/) format.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/commitlint@master
  with:
    from-sha: ${{ github.event.pull_request.base.sha }}
    to-sha: ${{ github.event.pull_request.head.sha }}
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `node-version` | No | `20` | Node.js version |
| `from-sha` | No | `""` | SHA to start validation from (for PRs) |
| `to-sha` | No | `""` | SHA to end validation at (for PRs) |
| `config-file` | No | `""` | Path to commitlint config file |

## Outputs

| Output | Description |
|:-------|:------------|
| `valid` | Whether all commits are valid |

## Behavior

- When `from-sha` and `to-sha` are provided, validates all commits in that range
- When omitted, validates only the last commit
- Custom config files are supported via the `config-file` input
