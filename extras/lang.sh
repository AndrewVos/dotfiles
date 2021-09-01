#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

asdf plugin add ruby ||:
asdf install ruby 2.7.1
asdf global ruby 2.7.1

asdf plugin add nodejs ||:
NODEJS_CHECK_SIGNATURES=no asdf install nodejs latest ||:
asdf install nodejs 14.15.0
asdf global nodejs 14.15.0

if ! which yarn; then
  npm install -g yarn
fi

if ! which eslint; then
  yarn global add eslint
fi
