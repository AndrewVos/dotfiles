#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$SHELL" != "/usr/bin/fish" ]]; then
  sudo usermod --shell /usr/bin/fish "$USER"
fi
