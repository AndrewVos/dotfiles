#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "hub" &> /dev/null; then
  cd $(mktemp -d)
  sudo apt install -y wget
  wget -O hub.tgz "https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz"
  tar -xvzf hub.tgz
  sudo cp "hub-linux-amd64-2.3.0-pre10/bin/hub" "/usr/local/bin/hub"
  cd -
fi
