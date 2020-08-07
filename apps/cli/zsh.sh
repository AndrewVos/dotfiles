#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "zsh" &> /dev/null; then
  sudo apt update -y
  sudo apt install -y zsh
fi

if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
  sudo usermod --shell /usr/bin/zsh "$USER"
fi
