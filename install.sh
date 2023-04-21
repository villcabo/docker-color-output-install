#!/bin/bash
echo "|------------------------------------|"
echo "|--> Settings docker-color-output <--|"
echo "|------------------------------------|"

# Download commads
BASHRCFILE=$HOME/.bashrc
DOCKER_COLOR_OUTPUT_FILE=$HOME/.docker_color_settings

if [ -f "$DOCKER_COLOR_OUTPUT_FILE" ]; then
    rm $DOCKER_COLOR_OUTPUT_FILE
fi
wget -q https://raw.githubusercontent.com/villcabo/docker-color-output/main/dockercolor_aliases.sh -O $DOCKER_COLOR_OUTPUT_FILE
echo "|--> .docker_color_settings successfull downloaded in $DOCKER_COLOR_OUTPUT_FILE"

isInFile=$(cat $BASHRCFILE | grep -c '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"')
if [ $isInFile -eq 0 ]; then
    echo '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"' >>$BASHRCFILE
    echo "|--> .docker_color_settings successfull added to $BASHRCFILE"
else
    echo "|--> .docker_color_settings already exists in $BASHRCFILE"
fi
#source $BASHRCFILE
#source $DOCKER_COLOR_OUTPUT_FILE
