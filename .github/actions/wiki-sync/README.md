# 📚 Wiki Sync

Sync a `wiki/` directory to the GitHub Wiki using [github-wiki-action](https://github.com/Andrew-Chen-Wang/github-wiki-action).

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/wiki-sync@master
  with:
    wiki-path: "wiki/"
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `wiki-path` | No | `wiki/` | Path to wiki directory |
| `ignore-file` | No | `.gitignore` | File with patterns to ignore |

## Outputs

| Output | Description |
|:-------|:------------|
| `synced` | Whether wiki was synced |

## Requirements

- The GitHub Wiki must be enabled and initialized for the repository
- The workflow needs `contents: write` permission
