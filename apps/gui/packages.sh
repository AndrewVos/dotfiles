#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y \
  mpv \
  krita \
  xclip \
  flameshot \
  gnome-tweak-tool

sudo snap install \
  pick-colour-picker
