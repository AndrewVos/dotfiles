#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y curl gnupg2

if [[ ! -f "$HOME/.nvm/nvm.sh" ]]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
fi

if ! command -v yarn &> /dev/null; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update -y
  sudo apt-get install -y yarn
fi
