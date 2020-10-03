#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mkdir -p "$HOME/.config/Typora/conf"
rm "$HOME/.config/Typora/conf/conf.default.json" ||:
rm "$HOME/.config/Typora/conf/conf.user.json" ||:

stow --verbose --dir "$HOME/.dotfiles/configs" --target ~ $(ls "$HOME/.dotfiles/configs")
