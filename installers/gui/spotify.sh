#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "spotify" &> /dev/null; then
  sudo apt install -y gnupg2 curl
  curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
  if [[ ! -f /etc/apt/sources.list.d/spotify.list ]]; then
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  fi
  sudo apt-get update -y
  sudo apt install -y spotify-client
fi
