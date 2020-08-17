#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y \
  git \
  stow

stow --verbose --dir "$HOME/.dotfiles/configs" --target ~ $(ls "$HOME/.dotfiles/configs")

LINE="source $HOME/.dotfiles/bash/init.sh"
if ! grep --line-regexp --fixed-strings "$LINE" "$HOME/.bashrc" > /dev/null; then
  echo "$LINE" >> $HOME/.bashrc
fi
