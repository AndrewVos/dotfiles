#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y \
  git \
  stow

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

stow --verbose --dir "$HOME/.dotfiles" --target ~ bash ctags git ssh vim

LINE="source $HOME/.dotfiles/bash/init.sh"
if ! grep --line-regexp --fixed-strings "$LINE" "$HOME/.bashrc" > /dev/null; then
  echo "$LINE" >> $HOME/.bashrc
fi
