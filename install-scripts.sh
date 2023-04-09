#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function add-line-to-file() {
    FILE="$1"
    LINE="$2"

    grep -qxF "$LINE" "$FILE" || echo "$LINE" >>"$FILE"
}

if [[ "$SHELL" = "/bin/bash" ]]; then
    add-line-to-file "$HOME/.bashrc" 'export PATH="$HOME/.dotfiles/scripts:$PATH"'
fi
PATH="$HOME/.dotfiles/scripts:$PATH"
