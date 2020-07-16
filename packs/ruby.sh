#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y \
  wget \
  make

if ! command -v ruby-install &> /dev/null; then
  OLD_PWD=$(pwd)
  cd $(mktemp -d)
  wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
  tar -xzvf ruby-install-0.7.0.tar.gz
  cd ruby-install-0.7.0/
  sudo make install
  cd "$OLD_PWD"
fi

if ! [[ -f "/usr/local/share/chruby/chruby.sh" ]]; then
  OLD_PWD=$(pwd)
  cd $(mktemp -d)
  wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  cd chruby-0.3.9/
  sudo make install
  cd "$OLD_PWD"
fi
