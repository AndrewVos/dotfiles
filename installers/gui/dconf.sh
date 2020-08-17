#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if command -v "dconf" &> /dev/null; then
  dconf load / < "$HOME/.dotfiles/config.dconf"
  dconf load / < "$HOME/.dotfiles/tilix.dconf"
fi
