#!/bin/bash -e

ARGUMENT=$1
if [ "$ARGUMENT" != "install" ] && [ "$ARGUMENT" != "update" ]; then
  echo 'Usage: ./plugins.sh install|update'
  exit 1
fi

function installOrUpdatePlugin() {
  name=$1
  dir=~/.vim/bundle/$(echo $name | cut -d "/" -f 2)

  if [ ! -d "$dir" ]; then
    echo Installing $name...
    git clone -q https://github.com/$name $dir
    return
  else
    if [ "$ARGUMENT" = "update" ]; then
      echo Updating $name...
      cd $dir
      git pull -q
    fi
    if [ "$ARGUMENT" = "install" ]; then
      echo Already installed $name...
    fi
  fi
}

function updateHelptags() {
  vim -c :Helptags -c :q -c :q
}

installOrUpdatePlugin 'tpope/vim-pathogen'

installOrUpdatePlugin 'tpope/vim-sleuth'
installOrUpdatePlugin 'tpope/vim-sensible'
installOrUpdatePlugin 'tpope/vim-unimpaired'
installOrUpdatePlugin 'tpope/vim-surround'
installOrUpdatePlugin 'tpope/vim-commentary'
installOrUpdatePlugin 'tpope/vim-cucumber'
installOrUpdatePlugin 'tpope/vim-fugitive'
installOrUpdatePlugin 'tpope/vim-vinegar'
installOrUpdatePlugin 'tpope/vim-jdaddy'
installOrUpdatePlugin 'pangloss/vim-javascript'
installOrUpdatePlugin 'jamessan/vim-gnupg'
installOrUpdatePlugin 'kchmck/vim-coffee-script'
installOrUpdatePlugin 'scrooloose/syntastic'
installOrUpdatePlugin 'mattn/webapi-vim'
installOrUpdatePlugin 'vim-scripts/Gist.vim'
installOrUpdatePlugin 'rking/ag.vim'
installOrUpdatePlugin 'AndrewVos/vim-aaa'
installOrUpdatePlugin 'fatih/vim-go'
installOrUpdatePlugin 'AndrewVos/dodo'
installOrUpdatePlugin 'AndrewRadev/splitjoin.vim'
installOrUpdatePlugin 'airblade/vim-gitgutter'
installOrUpdatePlugin 'ekalinin/Dockerfile.vim'
installOrUpdatePlugin 'mhinz/vim-startify'

updateHelptags
