#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mkdir -p "$HOME/.config/kak/plugins"
if [[ ! -d "$HOME/.config/kak/plugins/plug.kak" ]]; then
  git clone "https://github.com/robertmeta/plug.kak.git" "$HOME/.config/kak/plugins/plug.kak"
fi
