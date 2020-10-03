#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo pacman -Syu
sudo yay -Syu

asdf update
asdf plugin update --all

for directory in $(ls "$HOME/.vim/bundle"); do
  git -C "$HOME/.vim/bundle/$directory" pull
done
vim -c Helptags -c q

for directory in $(ls "$HOME/.zsh"); do
  git -C "$HOME/.zsh/$directory" pull
done
