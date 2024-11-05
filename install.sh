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
echo -e "\033[1m➔ .Downloading .docker_color_settings in $DOCKER_COLOR_OUTPUT_FILE ⏳...\033[0m"
wget -q https://raw.githubusercontent.com/villcabo/docker-color-output/main/dockercolor_aliases.sh -O $DOCKER_COLOR_OUTPUT_FILE
echo -e "\033[1m➔ .docker_color_settings successfull downloaded in $DOCKER_COLOR_OUTPUT_FILE ✔\033[0m"

isInFile=$(cat $BASHRCFILE | grep -c '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"')
if [ $isInFile -eq 0 ]; then
    echo -e "\033[1m➔ Adding .docker_color_settings to $BASHRCFILE ⏳...\033[0m"
    echo '[[ -s "$HOME/.docker_color_settings" ]] && source "$HOME/.docker_color_settings"' >>$BASHRCFILE
    echo -e "\033[1m➔ .docker_color_settings successfull added to $BASHRCFILE ✔\033[0m"
    echo -e "\033[1m    ➔ execute ➔ "source $BASHRCFILE"\033[0m"

else
    echo -e "\033[1m➔ .docker_color_settings already exists in $BASHRCFILE ✔\033[0m"
fi
#source $BASHRCFILE
#source $DOCKER_COLOR_OUTPUT_FILE
