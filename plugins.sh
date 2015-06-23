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
rking/ag.vim
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
"

function install() {
  for plugin in $plugins; do
    dir=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

    if [ ! -d "$dir" ]; then
      echo [install] $plugin...
      git clone -q https://github.com/$plugin $dir
    else
      if [ "$UPDATE" = "yes" ]; then
        echo [update] $plugin...
        cd $dir
        git pull -q
      fi
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

UPDATE="no"
if [[ "$@" == *"--update"* ]]; then
  echo "Updating all plugins..."
  UPDATE="yes"
else
  echo "Installing all plugins..."
fi
install

DELETE="no"
if [[ "$@" == *"--delete"* ]]; then
  echo "Deleting old plugins..."
  delete
  DELETE="yes"
fi

echo
echo Updating helptags...
vim -c :Helptags -c :q -c :q
