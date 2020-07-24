#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ ! -f "$HOME/.nvm/nvm.sh" ]]; then
  sudo apt install -y curl gnupg2
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
fi
