#!/bin/bash
echo "|-----------------------------------|"
echo "|--> Install docker-color-output <--|"
echo "|-----------------------------------|"

rm /usr/bin/docker-color-output
sudo wget -q https://github.com/devemio/docker-color-output/releases/download/2.3.0/docker-color-output-linux-amd64 -O /usr/bin/docker-color-output
chmod 755 /usr/bin/docker-color-output
echo "|--> docker-color-output installed successfull in /usr/bin"
docker-color-output
