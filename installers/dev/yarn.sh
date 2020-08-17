#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v yarn &> /dev/null; then
  sudo apt install -y curl gnupg2
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update -y
  sudo apt-get install -y yarn
fi
