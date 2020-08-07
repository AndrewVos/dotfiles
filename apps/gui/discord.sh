#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function reinstall-discord() {
  sudo apt update -y
  sudo DEBIAN_FRONTEND=noninteractive apt install -y -q \
    keyboard-configuration \
    wget

  wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O /tmp/discord.deb
  sudo apt install -y -q /tmp/discord.deb
  LATEST_DISCORD_VERSION=$(curl --silent -I 'https://discordapp.com/api/download?platform=linux&format=deb'| grep 'location:' | cut -d ' ' -f 2)
  echo "$LATEST_DISCORD_VERSION" > "$HOME/.installed-discord-version"
}

if [[ "$UPGRADE" = "yes" ]]; then
  CURRENT_DISCORD_VERSION=$(cat "$HOME/.installed-discord-version" ||:)
  LATEST_DISCORD_VERSION=$(curl --silent -I 'https://discordapp.com/api/download?platform=linux&format=deb'| grep 'location:' | cut -d ' ' -f 2)

  if [[ "$CURRENT_DISCORD_VERSION" != "$LATEST_DISCORD_VERSION" ]]; then
    reinstall-discord
  fi
elif ! command -v "discord" &> /dev/null; then
  reinstall-discord
fi
