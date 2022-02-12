#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo pacman -Syu
sudo pacman -Sy archlinux-keyring
sudo pacman -Su
yay -Syu

asdf plugin update --all
