# 🐳 Docker Build (Reusable Workflow)

Multi-platform Docker image builds using native runners (AMD64 + ARM64 in parallel) with manifest merging. Includes SBOM generation and provenance attestations.

## Usage

```yaml
jobs:
  docker:
    uses: fulviofreitas/workflow-arsenal/.github/workflows/docker-build.yml@master
    with:
      image-name: ghcr.io/myorg/myimage
      push: true
    secrets:
      registry-password: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `image-name` | **Yes** | — | Docker image name (e.g., `ghcr.io/org/repo`) |
| `context` | No | `.` | Docker build context |
| `dockerfile` | No | `Dockerfile` | Path to Dockerfile |
| `push` | No | `false` | Push image to registry |
| `registry` | No | `ghcr.io` | Container registry |
| `registry-username` | No | `""` | Registry username |
| `build-args` | No | `""` | Build arguments |
| `annotations` | No | `""` | Image annotations |
| `generate-sbom` | No | `true` | Generate SBOM |
| `generate-provenance` | No | `true` | Generate provenance attestation |

## Secrets

| Secret | Required | Description |
|:-------|:---------|:------------|
| `registry-password` | No | Registry password/token |

## Outputs

| Output | Description |
|:-------|:------------|
| `digest` | Image digest |
| `tags` | Image tags |

## How It Works

1. **Build**: AMD64 and ARM64 images built in parallel on native runners
2. **Merge**: Manifest list created combining both architectures
3. **Attest**: SBOM and provenance attestations generated and attached
