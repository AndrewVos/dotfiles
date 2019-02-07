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
    dir=.vim/bundle/$(echo $plugin | cut -d "/" -f 2)

    if [ ! -d "$dir" ]; then
      echo "${light_green}[install]${normal} $plugin"
      git clone -q https://github.com/$plugin $dir
    fi
  done
}

function update() {
  for plugin in $PLUGINS; do
    dir=.vim/bundle/$(echo $plugin | cut -d "/" -f 2)
    if [ -d "$dir" ]; then
      echo "${light_blue}[update]${normal} $plugin"
      cd $dir
      git pull -q
      git log --oneline ORIG_HEAD..HEAD
      cd - > /dev/null
    fi
  done
}

function delete() {
  for plugin_directory in $(ls -d .vim/bundle/*); do
    should_be_installed="no"
    for plugin in $PLUGINS; do
      expected_plugin_directory=.vim/bundle/$(echo $plugin | cut -d "/" -f 2)
      if [ "$plugin_directory" == "$expected_plugin_directory" ]; then
        should_be_installed="yes"
        break
      fi
    done

    if [ $should_be_installed == "no" ]; then
      echo "${light_red}[delete]${normal} $plugin_directory"
      prompt_to_delete_directory $plugin_directory
    fi
  done
}

function prompt_to_delete_directory() {
  DIRECTORY="$1"
  echo -n "rm -rf \"$DIRECTORY\" (y/n)? "
  old_stty_cfg=$(stty -g)
  stty raw -echo
  answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
  stty $old_stty_cfg
  echo

  if echo "$answer" | grep -iq "^y" ;then
    rm -rf "$DIRECTORY"
  fi
}

function update-help-tags() {
  vim -c :Helptags -c :q -c :q
}

if [[ "$@" == *"--help"* ]]; then
  echo "Usage: $0 [--update]";
  exit 0
fi

install
delete
if [[ "$@" == *"--update"* ]]; then
  update
fi
update-help-tags
