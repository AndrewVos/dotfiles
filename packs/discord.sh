#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "discord" &> /dev/null; then
  sudo DEBIAN_FRONTEND=noninteractive apt install -y keyboard-configuration
  sudo apt install -y wget
  wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O /tmp/discord.deb
  sudo apt install -y /tmp/discord.deb
fi
