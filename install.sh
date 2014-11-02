#!/bin/bash -e

mkdir -p .vim

for file in .vim .vimrc; do
 if [[ -e "$HOME/$file" ]]; then
   echo $HOME/$file already exists. You\'ll need to do something with it.
   exit 1
 else
  echo Symlinking `pwd`/$file to $HOME/$file
  ln -s `pwd`/$file $HOME/$file
 fi
done

./plugins.sh
