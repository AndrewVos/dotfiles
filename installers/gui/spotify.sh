#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "spotify" &> /dev/null; then
  curl -Ss https://download.spotify.com/debian/pubkey.gpg | gpg --import -
  yay -S --nopgpfetch --noconfirm spotify
fi
