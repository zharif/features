#!/bin/bash

# This test file will be executed against a devcontainer.json that
# includes the 'bitwarden-secrets-cli' feature with version "1.0.0".

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "bws is installed" bash -c "which bws"
check "bws version is 1.0.0" bash -c "bws --version | grep '1.0.0'"

# Report results
reportResults
