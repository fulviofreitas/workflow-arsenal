# 🛡️ Security Semgrep

Run [Semgrep](https://semgrep.dev/) security scanning with SARIF output for the GitHub Security tab. Supports Python, JavaScript, TypeScript, and custom rulesets.

## Usage

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/security-semgrep@master
  with:
    config: "p/python p/security-audit"
    target-path: "src/"
    fail-on-findings: true
```

**Multi-language with custom rules:**

```yaml
- uses: fulviofreitas/workflow-arsenal/.github/actions/security-semgrep@master
  with:
    config: "p/python p/javascript security-rules/"
    target-path: "."
```

## Inputs

| Input | Required | Default | Description |
|:------|:---------|:--------|:------------|
| `config` | No | `p/python p/security-audit` | Semgrep config (rulesets, space-separated) |
| `target-path` | No | `.` | Path to scan |
| `exclude-paths` | No | `tests/,**/test_*.py,...` | Paths to exclude (comma-separated) |
| `severity` | No | `WARNING` | Minimum severity (`INFO`, `WARNING`, `ERROR`) |
| `fail-on-findings` | No | `true` | Fail the job on findings |
| `upload-sarif` | No | `true` | Upload SARIF to GitHub Security |
| `sarif-output` | No | `semgrep.sarif` | SARIF output filename |
| `working-directory` | No | `.` | Working directory |

## Outputs

| Output | Description |
|:-------|:------------|
| `findings-count` | Number of security findings |
| `passed` | Whether scan passed (no findings) |

## Features

- SARIF output uploaded to GitHub Security tab
- Scan results uploaded as artifacts (30-day retention)
- Configurable severity threshold
- Custom ruleset support alongside community rulesets
