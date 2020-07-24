#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function install-latest-golang() {
  sudo apt install -y curl
  local LATEST_GO_VERSION=$(curl https://golang.org/VERSION?m=text)
  local INSTALLED_GO_VERSION="$(cat "$HOME/.installed-go-version")"
  if [[ "$INSTALLED_GO_VERSION" != "$LATEST_GO_VERSION" ]]; then
    sudo apt install -y wget
    wget -O /tmp/golang.tar.gz "https://dl.google.com/go/$LATEST_GO_VERSION.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf /tmp/golang.tar.gz
    echo "$LATEST_GO_VERSION" > "$HOME/.installed-go-version"
  fi
}

if [[ ! -f /usr/local/go/bin/go ]]; then
  install-latest-golang
elif [[ "$UPGRADE" = "yes" ]]; then
  install-latest-golang
fi
