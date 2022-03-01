#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

asdf plugin add ruby ||:
asdf install ruby 2.7.1
asdf global ruby 2.7.1

asdf plugin add nodejs ||:
asdf install nodejs latest ||:
asdf install nodejs 14.17.0
asdf global nodejs 14.17.0

asdf reshim

if ! which yarn; then
  npm install -g yarn
fi

if ! which eslint; then
  yarn global add eslint
fi
