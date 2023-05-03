#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
source ./helpers.sh

if [ ! -d "$HOME/.asdf" ]; then
    git clone "https://github.com/asdf-vm/asdf.git" "$HOME/.asdf" --branch v0.11.3
fi

if [[ "$SHELL" = "/bin/bash" ]]; then
    add-line-to-file "$HOME/.bashrc" '. "$HOME/.asdf/asdf.sh"'
    add-line-to-file "$HOME/.bashrc" '. "$HOME/.asdf/completions/asdf.bash"'
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash"
elif [[ "$SHELL" = "/bin/zsh" ]]; then
    add-line-to-file "$HOME/.zshrc" '. "$HOME/.asdf/asdf.sh"'
    . "$HOME/.asdf/asdf.sh"
fi

asdf plugin list | grep --quiet nodejs || asdf plugin add nodejs
NODEJS_VERSION="19.8.1"
asdf list nodejs | grep --quiet "$NODEJS_VERSION" || asdf install nodejs "$NODEJS_VERSION"
