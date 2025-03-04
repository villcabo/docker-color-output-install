#!/bin/bash

# Color codes for logging
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to log messages
log() {
    local level="$1"
    local message="$2"
    local icon=""

    case "$level" in
        "info")
            icon="ℹ️"
            echo -e "${BLUE}${icon} ${message}${NC}"
            ;;
        "success")
            icon="✅"
            echo -e "${GREEN}${icon} ${message}${NC}"
            ;;
        "warning")
            icon="⚠️"
            echo -e "${YELLOW}${icon} ${message}${NC}"
            ;;
        "error")
            icon="❌"
            echo -e "${RED}${icon} ${message}${NC}"
            ;;
    esac
}

# Function to display usage
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -v, --version VERSION   Specify the version to install (default: latest)"
    echo "  -h, --help              Display this help message"
}

# Default to latest version
VERSION="latest"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log "error" "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Start installation process
log "info" "Starting Docker Color Output installation"

# Determine download URL based on version
if [[ "$VERSION" == "latest" ]]; then
    LATEST_URL="https://github.com/devemio/docker-color-output/releases/latest/download/docker-color-output-linux-amd64"
    log "info" "Downloading latest version"
else
    LATEST_URL="https://github.com/devemio/docker-color-output/releases/download/v${VERSION}/docker-color-output-linux-amd64"
    log "info" "Downloading version ${VERSION}"
fi

# Remove old versions
log "warning" "Removing existing installations"
rm -f /usr/bin/docker-color-output
rm -f /usr/local/bin/docker-color-output

# Download the specified version
if wget -q "$LATEST_URL" -O /usr/local/bin/docker-color-output; then
    # Set permissions
    chmod 755 /usr/local/bin/docker-color-output
    
    log "success" "Docker Color Output installed successfully in /usr/local/bin"
    
    # Verify installation
    if /usr/local/bin/docker-color-output --version &> /dev/null; then
        log "success" "Installation verified successfully"
    else
        log "error" "Installation verification failed"
        exit 1
    fi
else
    log "error" "Failed to download Docker Color Output"
    exit 1
fi
