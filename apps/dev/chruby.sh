#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! [[ -f "/usr/local/share/chruby/chruby.sh" ]]; then
  sudo apt install -y wget make

  wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  cd chruby-0.3.9/
  sudo make install
fi
