
# Bitwarden Secrets CLI (bitwarden-secrets-cli)

Installs the Bitwarden Secrets Manager CLI (bws) for managing secrets

## Example Usage

```json
"features": {
    "ghcr.io/zharif/features/bitwarden-secrets-cli:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of bws CLI to install (e.g., '1.0.0' or 'latest') | string | latest |

## Usage

After installation, the `bws` command will be available in your dev container:

```bash
# Check version
bws --version

# Login with access token
bws login

# Get help
bws --help
```

## About Bitwarden Secrets Manager

Bitwarden Secrets Manager is a secure secrets management solution for developers and DevOps teams. The CLI tool (`bws`) allows you to manage your secrets directly from the command line.

For more information, see the [Bitwarden Secrets Manager CLI documentation](https://bitwarden.com/help/secrets-manager-cli/).

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/zharif/features/blob/main/src/bitwarden-secrets-cli/devcontainer-feature.json). Add additional notes to a `NOTES.md`._
