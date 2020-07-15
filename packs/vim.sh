#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function git-clone() {
  URL=$1
  CLONE_PATH=$2

  if [[ -d "$CLONE_PATH" ]]; then
    git clone "$URL" "$CLONE_PATH"
  fi
}

sudo apt install -y \
  libncurses5-dev \
  libatk1.0-dev \
  libcairo2-dev \
  libx11-dev \
  libxpm-dev \
  libxt-dev \
  python3-dev \
  ruby-dev \
  libperl-dev

CLONE_PATH=$(mktemp -d)
cd "$CLONE_PATH"
git clone git@github.com:vim/vim.git "$CLONE_PATH"
cd "$CLONE_PATH/src"
./configure --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-python3interp=yes \
            --with-python3-config-dir=/usr/lib/python3.5/config \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-cscope \
            --prefix=/usr \
            --enable-gui=auto --enable-gtk2-check --with-x
make
sudo make install

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
"

for PLUGIN in $PLUGINS; do
  PLUGIN_NAME=$(echo "$PLUGIN" | cut -d "/" -f 2)
  git-clone "https://github.com/$PLUGIN" "$HOME/.vim/bundle/$PLUGIN_NAME"
done

# generate docs
vim -c Helptags -c q
