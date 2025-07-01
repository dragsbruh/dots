#!/usr/bin/bash

set -e

curl -fSL "https://discord.com/api/download?platform=linux&format=tar.gz" -o "discord.tar.gz"
tar -xvf discord.tar.gz

sudo rm -rf /opt/discord/resources/ /opt/discord/locales/
sudo mv Discord/* /opt/discord/

equictl -install

rm -rf Discord discord.tar.gz
