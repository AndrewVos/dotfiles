#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mkdir -p "$HOME/.config/Typora/conf"

stow --verbose --dir "$HOME/.dotfiles/configs" --target ~ $(ls "$HOME/.dotfiles/configs")

LINE="source $HOME/.dotfiles/bash/init.sh"
if ! grep --line-regexp --fixed-strings "$LINE" "$HOME/.bashrc" > /dev/null; then
  echo "$LINE" >> $HOME/.bashrc
fi
