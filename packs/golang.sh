#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ ! -f /usr/local/go/bin/go ]]; then
  cd $(mktemp -d)
  sudo apt install -y wget
  wget -O golang.tar.gz https://golang.org/dl/go1.14.5.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf golang.tar.gz
  cd -
fi
