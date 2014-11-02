#!/bin/bash -e

function installOrUpdatePlugin() {
  name=$1
  dir=~/.vim/bundle/$(echo $name | cut -d "/" -f 2)

  if [ -d "$dir" ]; then
    echo Updating $name...
    cd $dir
    git pull -q
  else
    echo Installing $name...
    git clone -q https://github.com/$name $dir
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

updateHelptags
