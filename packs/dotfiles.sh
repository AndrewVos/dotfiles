#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y \
  git \
  stow

function git-clone() {
  URL=$1
  CLONE_PATH=$2

  if [[ ! -d "$CLONE_PATH" ]]; then
    git clone "$URL" "$CLONE_PATH"
  fi
}

git-clone "https://github.com/AndrewVos/dotfiles" "$HOME/.dotfiles"
stow --verbose --dir "$HOME/.dotfiles" --target ~ bash ctags git ssh vim

LINE="source ~/.dotfiles/bash/init.sh"
if ! grep --line-regexp --fixed-strings "$LINE" "~/.bashrc" > /dev/null; then
  echo "$LINE" >> ~/.bashrc
fi
