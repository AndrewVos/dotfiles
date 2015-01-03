#!/bin/bash -e

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
"

UPDATE=$1

if [ "$UPDATE" != "--update" ]; then
  echo "Only installing plugins if they don't exist. Use --update to update all plugins."
  echo
fi

for plugin in $plugins; do
  dir=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

  if [ ! -d "$dir" ]; then
    echo [install] $plugin...
    git clone -q https://github.com/$plugin $dir
  else
    if [ "$UPDATE" = "--update" ]; then
      echo [update] $plugin...
      cd $dir
      git pull -q
    else
      echo [ignore] $plugin...
    fi
  fi
done

echo
echo Updating helptags...
vim -c :Helptags -c :q -c :q
