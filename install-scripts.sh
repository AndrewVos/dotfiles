#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ./helpers.sh

if [[ "$SHELL" = "/bin/bash" ]]; then
    add-line-to-file "$HOME/.bashrc" 'export PATH="$HOME/.dotfiles/scripts:$PATH"'
fi
PATH="$HOME/.dotfiles/scripts:$PATH"
