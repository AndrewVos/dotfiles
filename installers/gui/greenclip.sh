#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "greenclip" &> /dev/null; then
  wget -O greenclip 'https://github.com/erebe/greenclip/releases/download/3.3/greenclip'
  chmod +x greenclip
  sudo mv greenclip /usr/local/bin/greenclip
fi
