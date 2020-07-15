#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "exa" &> /dev/null; then
  sudo apt install -y wget unzip
  wget https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip -O exa.zip
  unzip exa.zip
  sudo cp exa-linux-x86_64 /usr/local/bin/exa
fi
