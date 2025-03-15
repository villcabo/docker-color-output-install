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
GITHUB_RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/docker_configuration/${SETTINGS_FILE_PATH}"

# Paths
BASH_ALIASES_FILE="$HOME/.bash_aliases"
ZSHRC_FILE="$HOME/.zshrc"
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
            echo -e "${RED}${BOLD}➔ Unknown option: $1${NORMAL}"
            usage
            exit 1
            ;;
    esac
done

# Set default download URL if not specified
DOWNLOAD_URL=$GITHUB_RAW_URL

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

# Function to add settings to shell configuration file
add_settings_to_shell() {
    local shell_rc_file=$1
    if grep -q '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"' "$shell_rc_file"; then
        echo -e "${YELLOW}${BOLD}➔ Docker Color Output settings already exist in $shell_rc_file${NORMAL}"
        echo -e "${BOLD}➔ To apply changes, run: ${BLUE}${BOLD}${ITALIC}source $shell_rc_file${NORMAL}"
    else
        echo -e "${BOLD}➔ Adding Docker Color Output settings to $shell_rc_file ⏳...${NORMAL}"
        echo '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"' >> "$shell_rc_file"
        echo -e "${GREEN}${BOLD}➔ Docker Color Output settings added to $shell_rc_file${NORMAL}"
        echo -e "${BOLD}➔ To apply changes, run: ${BLUE}${BOLD}${ITALIC}source $shell_rc_file${NORMAL}"
    fi
}

# Create .bash_aliases if it doesn't exist
if [ ! -f "$BASH_ALIASES_FILE" ]; then
    echo -e "${BOLD}➔ Creating ${ITALIC}$BASH_ALIASES_FILE${QUIT_ITALIC} file ⏳...${NORMAL}"
    touch "$BASH_ALIASES_FILE"
    echo -e "${GREEN}${BOLD}➔ Created ${ITALIC}$BASH_ALIASES_FILE${QUIT_ITALIC} file${NORMAL}"
fi

# Add settings to .bash_aliases
add_settings_to_shell "$BASH_ALIASES_FILE"

# Add settings to .zshrc if it exists
if [ -f "$ZSHRC_FILE" ]; then
    add_settings_to_shell "$ZSHRC_FILE"
fi

echo -e "${GREEN}${BOLD}➔ Docker Color Output installation completed successfully ✅${NORMAL}"
