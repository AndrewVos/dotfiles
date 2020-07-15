#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "discord" &> /dev/null; then
  sudo apt update -y
  sudo DEBIAN_FRONTEND=noninteractive apt install -y -q \
    keyboard-configuration \
    wget

  wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O /tmp/discord.deb
  sudo apt install -y -q /tmp/discord.deb
fi
