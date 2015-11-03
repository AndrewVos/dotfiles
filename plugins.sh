#!/bin/bash

set -u
set -e

PLUGINS=$(cat plugins.txt)

function install() {
  for plugin in $PLUGINS; do
    dir=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

    if [ ! -d "$dir" ]; then
      echo [install] $plugin...
      git clone -q https://github.com/$plugin $dir
    fi
  done
}

function update() {
  for plugin in $PLUGINS; do
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
    for plugin in $PLUGINS; do
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
  install
elif [[ "$@" == *"--update"* ]]; then
  update
elif [[ "$@" == *"--delete"* ]]; then
  delete
fi

echo Updating helptags...
vim -c :Helptags -c :q -c :q
