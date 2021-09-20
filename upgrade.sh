#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo pacman -Syu
yay -Syu

asdf plugin update --all
