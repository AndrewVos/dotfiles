#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "hub" &> /dev/null; then
  sudo apt install -y wget
  wget -O hub.tgz "https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz"
  tar -xf hub.tgz
  sudo mv "hub-linux-amd64-2.14.2/bin/hub" /usr/local/bin/hub
fi
