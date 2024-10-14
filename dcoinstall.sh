#!/bin/bash
echo "|-----------------------------------|"
echo "|--> Install docker-color-output <--|"
echo "|-----------------------------------|"

# Get the latest version URL from GitHub API
LATEST_URL=$(curl -s https://api.github.com/repos/devemio/docker-color-output/releases/latest | grep "browser_download_url.*docker-color-output-linux-amd64" | cut -d '"' -f 4)

# Remove old version
rm -f /usr/bin/docker-color-output

# Download the latest version
wget -q $LATEST_URL -O /usr/bin/docker-color-output

# Set permissions
chmod 755 /usr/bin/docker-color-output

echo "|--> docker-color-output installed successfully in /usr/bin"
docker-color-output
