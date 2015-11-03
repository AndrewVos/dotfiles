#!/bin/bash

set -u
set -e

plugins="tpope/vim-pathogen
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
kchmck/vim-coffee-script
scrooloose/syntastic
mattn/webapi-vim
vim-scripts/Gist.vim
AndrewVos/vim-aaa
fatih/vim-go
AndrewVos/dodo
AndrewRadev/splitjoin.vim
airblade/vim-gitgutter
ekalinin/Dockerfile.vim
sjl/gundo.vim
tpope/vim-rails
reedes/vim-wordy
dietsche/vim-lastplace
stefandtw/quickfix-reflector.vim
AndrewVos/vim-git-navigator
chriskempson/vim-tomorrow-theme
godlygeek/tabular
ntpeters/vim-better-whitespace
junegunn/fzf
tpope/vim-eunuch
gorodinskiy/vim-coloresque
tpope/vim-abolish
int3/vim-extradite
tpope/vim-obsession
vim-ruby/vim-ruby
"

function install() {
  for plugin in $plugins; do
    dir=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

    if [ ! -d "$dir" ]; then
      echo [install] $plugin...
      git clone -q https://github.com/$plugin $dir
    fi
  done
}

function update() {
  for plugin in $plugins; do
    dir=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

    if [ -d "$dir" ]; then
      echo [update] $plugin...
      cd $dir
      git pull -q
    fi
  done
}

function delete() {
  for plugin_directory in $(ls -d ~/.vim/bundle/*/); do
    should_be_installed="no"
    for plugin in $plugins; do
      expected_plugin_directory=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)/
      if [ "$plugin_directory" == "$expected_plugin_directory" ]; then
        should_be_installed="yes"
        break
      fi
    done
    if [ $should_be_installed == "no" ]; then
      echo "[delete] $plugin_directory"
      rm -rfI "$plugin_directory"
    fi
  done
}

if [ $# -eq 0 ]; then
  echo "Usage: $0 [--install|--update|--delete]";
  exit 1;
fi

if [[ "$@" == *"--install"* ]]; then
  echo "Installing all plugins..."
  install
elif [[ "$@" == *"--update"* ]]; then
  echo "Updating all plugins..."
  update
elif [[ "$@" == *"--delete"* ]]; then
  echo "Deleting old plugins..."
  delete
fi

echo Updating helptags...
vim -c :Helptags -c :q -c :q
