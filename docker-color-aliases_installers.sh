#!/bin/bash

# Color codes for logging
NORMAL='\033[0m'
BOLD='\033[1m'
ITALIC='\033[3m'
QUIT_ITALIC='\033[23m'
UNDERLINE='\033[4m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub repository details
REPO_OWNER="villcabo"
REPO_NAME="docker-color-output"
SETTINGS_FILE_PATH="docker-color_aliases.sh"
GITHUB_RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/${SETTINGS_FILE_PATH}"

# Paths
BASHRC_FILE="$HOME/.bashrc"
DOCKER_COLOR_OUTPUT_FILE="$HOME/.docker_color_settings"

# Function to display usage
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -u, --url URL    Custom URL for docker color settings file"
    echo "  -h, --help       Display this help message"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
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

# Determine the URL to download from
DOWNLOAD_URL=${GITHUB_RAW_URL}

# Start installation process
echo -e "${BOLD}➔ Setting up Docker Color Output settings ⏳...${NORMAL}"

# Remove existing settings file if it exists
if [ -f "$DOCKER_COLOR_OUTPUT_FILE" ]; then
    echo -e "${BOLD}➔ Removing existing ${ITALIC}$HOME/.docker_color_settings${QUIT_ITALIC} file ⏳...${NORMAL}"
    rm "$DOCKER_COLOR_OUTPUT_FILE"
    echo -e "${GREEN}${BOLD}➔ Existing ${ITALIC}$HOME/.docker_color_settings${QUIT_ITALIC} file removed successfully${NORMAL}"
fi

# Download settings file
echo -e "${BOLD}➔ Downloading Docker Color Output settings ⏳...${NORMAL}"
if wget -q "$DOWNLOAD_URL" -O "$DOCKER_COLOR_OUTPUT_FILE"; then
    echo -e "${GREEN}${BOLD}➔ Docker Color Output settings downloaded successfully${NORMAL}"
else
    echo -e "${RED}${BOLD}➔ Docker Color Output settings download failed ❌${NORMAL}"
    exit 1
fi

# Check if settings are already in .bashrc
if grep -q '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"' "$BASHRC_FILE"; then
    echo -e "${YELLOW}${BOLD}➔ Docker Color Output settings already exist in $BASHRC_FILE${NORMAL}"
else
    # Add settings to .bashrc
    echo -e "${BOLD}➔ Adding Docker Color Output settings to $BASHRC_FILE ⏳...${NORMAL}"
    echo '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"' >> "$BASHRC_FILE"
    
    echo -e "${GREEN}${BOLD}➔ Docker Color Output settings added to $BASHRC_FILE${NORMAL}"
    echo -e "${YELLOW}${BOLD}➔ To apply changes, run: ${ITALIC}source $BASHRC_FILE${NORMAL}"
fi
