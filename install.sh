#!/bin/bash
cp docker-color-output-linux-amd64 /usr/local/bin/docker-color-ouput
chmod +x /usr/local/bin/docker-color-ouput
echo "docker-color-output installed successfull in /usr/local/bin"
docker-color-output

cp dockercolor_aliases.sh ~/.docker_color_settings
echo "docker_color_settings created successfull in ~/.docker_color_settings"

echo "if [ -f ~/.docker_color_settings ]; then\n\t. ~/.docker_color_settings\nfi" >> ~/.bashrc
echo "docker_color_settings successfull added to  ~/.bashrc"