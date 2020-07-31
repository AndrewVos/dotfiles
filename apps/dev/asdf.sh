#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function git-clone() {
  URL=$1
  CLONE_PATH=$2

  if [[ -d "$CLONE_PATH" ]]; then
    if [[ "$UPGRADE" = "yes" ]]; then
      git -C "$CLONE_PATH" pull
    fi
  else
    git clone "$URL" "$CLONE_PATH"
  fi
}

if ! [[ -f ~/.asdf/asdf.sh ]]; then
  sudo apt install -y curl git

  ASDF_PATH="$HOME/.asdf"
  git-clone "https://github.com/asdf-vm/asdf.git" "$ASDF_PATH"
  git -C "$ASDF_PATH" checkout "$(git -C "$ASDF_PATH" describe --abbrev=0 --tags)"

  source ~/.dotfiles/bash/init/asdf.sh
elif [[ "$UPGRADE" = "yes" ]]; then
  asdf update
  asdf plugin update --all
fi
