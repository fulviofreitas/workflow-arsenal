# 🚀 Semantic Release

Run [semantic-release](https://github.com/semantic-release/semantic-release) for automated versioning based on conventional commits.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/semantic-release@master
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

**Dry-run mode:**

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/semantic-release@master
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    dry-run: true
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `github-token` | **Yes** | — | GitHub token for creating releases |
| `node-version` | No | `20` | Node.js version |
| `dry-run` | No | `false` | Dry-run mode |
| `extra-plugins` | No | `""` | Additional plugins (comma-separated) |

## Outputs

| Output | Description |
|:-------|:------------|
| `released` | Whether a release was created |
| `version` | Released version (if any) |

## Included Plugins

- `@semantic-release/changelog@6`
- `@semantic-release/git@10`
- `@semantic-release/exec@6`
- `conventional-changelog-conventionalcommits@8`

Extra plugins can be added via the `extra-plugins` input.
