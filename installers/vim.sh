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
tpope/vim-repeat
scolsen/bernhard
kjssad/quantum.vim
nightsense/stellarized
raggi/vim-color-raggi
dense-analysis/ale
"

for PLUGIN in $PLUGINS; do
  PLUGIN_NAME=$(echo "$PLUGIN" | cut -d "/" -f 2)
  if [[ ! -d "$HOME/.vim/bundle/$PLUGIN_NAME" ]]; then
    git -C "$HOME/.vim/bundle" clone "https://github.com/$PLUGIN"
  fi
done

vim -c Helptags -c q
