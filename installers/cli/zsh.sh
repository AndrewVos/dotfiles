#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "zsh" &> /dev/null; then
  sudo apt update -y
  sudo apt install -y zsh
fi

if ! command -v "git" &> /dev/null; then
  sudo apt install -y git
fi

if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
  sudo usermod --shell /usr/bin/zsh "$USER"
fi

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

mkdir -p "$HOME/.zsh"

git-clone "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.zsh/zsh-autosuggestions"
git-clone "https://github.com/hlissner/zsh-autopair" "$HOME/.zsh/zsh-autopair"
