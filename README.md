# Dev Container Features

This repository contains dev container [Features](https://containers.dev/implementors/features/) hosted on GitHub Container Registry. Features are self-contained units of dev container configuration and installation code.

## Features

### `bitwarden-secrets-cli`

Installs the [Bitwarden Secrets Manager CLI (bws)](https://bitwarden.com/help/secrets-manager-cli/) for managing secrets in dev containers.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/zharif/features/bitwarden-secrets-cli:1": {}
    }
}
```

With a specific version:

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/zharif/features/bitwarden-secrets-cli:1": {
            "version": "1.0.0"
        }
    }
}
```

#### Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| `version` | Version of bws CLI to install (e.g., '1.0.0' or 'latest') | string | `latest` |

#### Usage

After installation, the `bws` command is available:

```bash
# Check version
bws --version

# Get help
bws --help
```

## Repo and Feature Structure

This repository follows the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/). Each Feature has its own sub-folder in `src`, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```
├── src
│   ├── bitwarden-secrets-cli
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`. Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

### Publishing

> NOTE: The Distribution spec can be [found here](https://containers.dev/implementors/features-distribution/).  
>
> While any registry [implementing the OCI Distribution spec](https://github.com/opencontainers/distribution-spec) can be used, this template will leverage GHCR (GitHub Container Registry) as the backing registry.

Features are meant to be easily sharable units of dev container configuration and installation code.  

This repo contains a **GitHub Action** [workflow](.github/workflows/release.yaml) that will publish each Feature to GHCR. 

*Allow GitHub Actions to create and approve pull requests* should be enabled in the repository's `Settings > Actions > General > Workflow permissions` for auto generation of `src/<feature>/README.md` per Feature (which merges any existing `src/<feature>/NOTES.md`).

By default, each Feature will be prefixed with the `<owner/<repo>` namespace. For example, the Feature in this repository can be referenced in a `devcontainer.json` with:

```
ghcr.io/zharif/features/bitwarden-secrets-cli:1
```

The provided GitHub Action will also publish a "metadata" package with just the namespace, eg: `ghcr.io/zharif/features`. This contains information useful for tools aiding in Feature discovery.

### Marking Feature Public

Note that by default, GHCR packages are marked as `private`. To stay within the free tier, Features need to be marked as `public`.

This can be done by navigating to the Feature's "package settings" page in GHCR, and setting the visibility to 'public'. The URL may look something like:

```
https://github.com/users/<owner>/packages/container/<repo>%2F<featureName>/settings
```

<img width="669" alt="image" src="https://user-images.githubusercontent.com/23246594/185244705-232cf86a-bd05-43cb-9c25-07b45b3f4b04.png">

### Adding Features to the Index

If you'd like your Features to appear in our [public index](https://containers.dev/features) so that other community members can find them, you can do the following:

* Go to [github.com/devcontainers/devcontainers.github.io](https://github.com/devcontainers/devcontainers.github.io)
     * This is the GitHub repo backing the [containers.dev](https://containers.dev/) spec site
* Open a PR to modify the [collection-index.yml](https://github.com/devcontainers/devcontainers.github.io/blob/gh-pages/_data/collection-index.yml) file

This index is from where [supporting tools](https://containers.dev/supporting) like [VS Code Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and [GitHub Codespaces](https://github.com/features/codespaces) surface Features for their dev container creation UI.

#### Using private Features in Codespaces

For any Features hosted in GHCR that are kept private, the `GITHUB_TOKEN` access token in your environment will need to have `package:read` and `contents:read` for the associated repository.

Many implementing tools use a broadly scoped access token and will work automatically. GitHub Codespaces uses repo-scoped tokens, and therefore you'll need to add the permissions in `devcontainer.json`

An example `devcontainer.json` can be found below.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
     "ghcr.io/zharif/features/bitwarden-secrets-cli:1": {}
    },
    "customizations": {
        "codespaces": {
            "repositories": {
                "zharif/features": {
                    "permissions": {
                        "packages": "read",
                        "contents": "read"
                    }
                }
            }
        }
    }
}
```
