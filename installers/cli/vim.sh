#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

PLUGINS="
tpope/vim-pathogen
tpope/vim-sleuth
tpope/vim-sensible
tpope/vim-unimpaired
tpope/vim-surround
tpope/vim-commentary
tpope/vim-fugitive
tpope/vim-vinegar
tpope/vim-jdaddy
pangloss/vim-javascript
jamessan/vim-gnupg
mattn/webapi-vim
vim-scripts/Gist.vim
AndrewVos/vim-aaa
AndrewVos/vim-ring
FooSoft/vim-argwrap
airblade/vim-gitgutter
dietsche/vim-lastplace
stefandtw/quickfix-reflector.vim
ntpeters/vim-better-whitespace
tpope/vim-eunuch
tpope/vim-abolish
int3/vim-extradite
tpope/vim-speeddating
Chiel92/vim-autoformat
terryma/vim-multiple-cursors
ap/vim-css-color
elixir-lang/vim-elixir
tpope/vim-rhubarb
kopischke/vim-fetch
kristijanhusak/vim-js-file-import
jeffkreeftmeijer/vim-dim
godlygeek/tabular
AndrewRadev/sideways.vim
mhinz/vim-startify
tpope/vim-haystack
AndrewVos/vim-git-navigator
baskerville/vim-sxhkdrc
mattn/emmet-vim
"

UPDATE_VIM_DOCS="no"
function git-clone() {
  URL=$1
  CLONE_PATH=$2

  if [[ -d "$CLONE_PATH" ]]; then
    if [[ "$UPGRADE" = "yes" ]]; then
      git -C "$CLONE_PATH" pull
      UPDATE_VIM_DOCS="yes"
    fi
  else
    git clone "$URL" "$CLONE_PATH"
    UPDATE_VIM_DOCS="yes"
  fi
}

for PLUGIN in $PLUGINS; do
  PLUGIN_NAME=$(echo "$PLUGIN" | cut -d "/" -f 2)
  git-clone "https://github.com/$PLUGIN" "$HOME/.vim/bundle/$PLUGIN_NAME"
done

if [[ "$UPDATE_VIM_DOCS" = "yes" ]]; then
  vim -c Helptags -c q
fi
