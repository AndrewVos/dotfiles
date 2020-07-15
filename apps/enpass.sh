#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ ! -f /opt/enpass/Enpass ]]; then
  sudo apt install -y wget gnupg2
  wget -O /tmp/enpass-linux.key https://apt.enpass.io/keys/enpass-linux.key
  sudo apt-key add /tmp/enpass-linux.key
  echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
  sudo apt-get update -y
  sudo apt install -y enpass
fi
