#!/bin/bash

set -u
set -e

PLUGINS=$(cat plugins.txt)

normal=""
light_red=""
light_green=""
light_blue=""

if [ -t 1 ]; then
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        normal="$(tput sgr0)"
        light_red="$(tput bold; tput setaf 1)"
        light_green="$(tput bold; tput setaf 2)"
        light_blue="$(tput bold; tput setaf 4)"
    fi
fi

function install() {
  for plugin in $PLUGINS; do
    dir=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

    if [ ! -d "$dir" ]; then
      echo "${light_green}[install]${normal} $plugin"
      git clone -q https://github.com/$plugin $dir
    fi
  done
}

function update() {
  for plugin in $PLUGINS; do
    dir=~/.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

    if [ -d "$dir" ]; then
      echo "${light_blue}[update]${normal} $plugin"
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
      echo "${light_red}[delete]${normal} $plugin_directory"
      rm -rfI "$plugin_directory"
    fi
  done
}

function usage() {
  echo "Usage: $0 [--install|--update|--delete]";
  exit 1;
}

function update-help-tags() {
  vim -c :Helptags -c :q -c :q
}

if [[ "$@" == *"--install"* ]]; then
  install
  update-help-tags
elif [[ "$@" == *"--update"* ]]; then
  update
  update-help-tags
elif [[ "$@" == *"--delete"* ]]; then
  delete
  update-help-tags
else
  usage
fi

