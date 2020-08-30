#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function download-file() {
  FILE_URL="$1"
  DOWNLOAD_PATH="$2"

  if [[ ! -f "$DOWNLOAD_PATH" ]] ; then
    wget "$FILE_URL" -O "$DOWNLOAD_PATH"
  fi
}

mkdir -p "$HOME/.wallpapers"
download-file "https://i.imgur.com/Uss9jsw.jpg" "$HOME/.wallpapers/Uss9jsw.jpg"
