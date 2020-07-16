#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ ! -f /usr/local/bin/hugo ]]; then
  cd $(mktemp -d)
  sudo apt install -y wget
  wget https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-64bit.tar.gz -O hugo.tar.gz
  tar -xzvf hugo.tar.gz
  sudo cp hugo /usr/local/bin/hugo
  cd -
fi
