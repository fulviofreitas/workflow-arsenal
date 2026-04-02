# 🐳 Docker Build

Build and push multi-platform Docker images with SBOM generation and provenance attestations.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/docker-build@master
  with:
    image-name: "ghcr.io/myorg/myimage"
    push: true
    registry-password: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `image-name` | **Yes** | — | Docker image name (e.g., `ghcr.io/org/repo`) |
| `context` | No | `.` | Docker build context |
| `dockerfile` | No | `Dockerfile` | Path to Dockerfile |
| `platforms` | No | `linux/amd64,linux/arm64` | Target platforms |
| `push` | No | `false` | Push image to registry |
| `registry` | No | `ghcr.io` | Container registry |
| `registry-username` | No | `""` | Registry username |
| `registry-password` | No | `""` | Registry password/token |
| `build-args` | No | `""` | Build arguments |
| `labels` | No | `""` | Image labels |
| `annotations` | No | `""` | Image annotations |
| `generate-sbom` | No | `true` | Generate SBOM |
| `generate-provenance` | No | `true` | Generate provenance attestation |

## Outputs

| Output | Description |
|:-------|:------------|
| `digest` | Image digest |
| `tags` | Image tags |
| `metadata` | Build metadata |

## Features

- Multi-platform builds via QEMU
- GitHub Actions cache for layer reuse
- Automatic semantic version tagging from git tags
- SBOM and provenance attestation generation
