#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
  sudo usermod --shell /usr/bin/zsh "$USER"
fi

mkdir -p "$HOME/.zsh"

if [[ ! -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
  git -C "$HOME/.zsh" clone "https://github.com/zsh-users/zsh-autosuggestions"
fi

if [[ ! -d "$HOME/.zsh/zsh-autopair" ]]; then
  git -C "$HOME/.zsh" clone "https://github.com/hlissner/zsh-autopair"
fi

if [[ ! -d "$HOME/.zsh/zsh-z" ]]; then
  git -C "$HOME/.zsh" clone "https://github.com/agkozak/zsh-z"
fi
