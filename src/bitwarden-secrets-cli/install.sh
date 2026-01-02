#!/bin/sh
set -e

echo "Activating feature 'bitwarden-secrets-cli'"

VERSION="${VERSION:-latest}"
echo "Requested bws version: $VERSION"

# Determine architecture
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

case "$ARCH" in
    x86_64|amd64)
        ARCH_NAME="x86_64"
        ;;
    aarch64|arm64)
        ARCH_NAME="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

case "$OS" in
    linux)
        PLATFORM="${ARCH_NAME}-unknown-linux-gnu"
        ;;
    darwin)
        PLATFORM="${ARCH_NAME}-apple-darwin"
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

echo "Detected platform: $PLATFORM"

# Install dependencies based on OS
install_dependencies() {
    if [ "$OS" = "linux" ]; then
        if command -v apt-get > /dev/null 2>&1; then
            apt-get update
            apt-get install -y curl unzip ca-certificates
        elif command -v apk > /dev/null 2>&1; then
            apk add --no-cache curl unzip ca-certificates
        elif command -v dnf > /dev/null 2>&1; then
            dnf install -y curl unzip ca-certificates
        elif command -v yum > /dev/null 2>&1; then
            yum install -y curl unzip ca-certificates
        else
            echo "Warning: Package manager not detected. Assuming dependencies are installed."
        fi
    elif [ "$OS" = "darwin" ]; then
        # macOS typically has curl built-in, unzip may need to be installed via brew
        if ! command -v unzip > /dev/null 2>&1; then
            if command -v brew > /dev/null 2>&1; then
                brew install unzip
            else
                echo "Error: unzip is required but not installed. Please install it manually."
                exit 1
            fi
        fi
    fi
}

install_dependencies

# Get the version to download
if [ "$VERSION" = "latest" ]; then
    echo "Fetching latest bws version..."
    # Use GitHub API to get bws releases and find the latest bws-v* tag
    API_RESPONSE=$(curl -fsSL "https://api.github.com/repos/bitwarden/sdk-sm/releases" 2>/dev/null || echo "")
    if [ -n "$API_RESPONSE" ]; then
        VERSION=$(echo "$API_RESPONSE" | grep -o '"tag_name": *"bws-v[^"]*"' | head -1 | sed 's/.*"bws-v\([^"]*\)".*/\1/')
    fi
    if [ -z "$VERSION" ]; then
        echo "Failed to fetch latest version, falling back to 1.0.0"
        VERSION="1.0.0"
    fi
fi

echo "Installing bws version: $VERSION"

# Construct download URL
DOWNLOAD_URL="https://github.com/bitwarden/sdk-sm/releases/download/bws-v${VERSION}/bws-${PLATFORM}-${VERSION}.zip"
echo "Downloading from: $DOWNLOAD_URL"

# Download and install
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

curl -fsSL -o bws.zip "$DOWNLOAD_URL"
unzip bws.zip
chmod +x bws
mv bws /usr/local/bin/bws

# Cleanup
cd /
rm -rf "$TEMP_DIR"

# Cleanup package manager cache on Linux
if [ "$OS" = "linux" ]; then
    if command -v apt-get > /dev/null 2>&1; then
        apt-get clean 2>/dev/null || true
        rm -rf /var/lib/apt/lists/* 2>/dev/null || true
    fi
fi

# Verify installation
echo "Verifying installation..."
bws --version

echo "Bitwarden Secrets CLI (bws) installed successfully!"
