#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "ngrok" &> /dev/null; then
  sudo apt install -y wget unzip
  wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O ngrok.zip
  unzip ngrok.zip
  sudo cp ngrok /usr/local/bin/ngrok
fi
