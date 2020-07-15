#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "heroku" &> /dev/null; then
  sudo apt install -y curl gnupg2
  curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
fi
