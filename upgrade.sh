#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo pacman -Syu
yay -Syu

asdf plugin update --all

for directory in $(ls "$HOME/.vim/bundle"); do
  git -C "$HOME/.vim/bundle/$directory" pull
done
vim -c Helptags -c q
