#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v ruby-install &> /dev/null; then
  sudo apt install -y wget make

  wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
  tar -xzvf ruby-install-0.7.0.tar.gz
  cd ruby-install-0.7.0/
  sudo make install
fi
