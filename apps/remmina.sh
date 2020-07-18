#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "remmina" &> /dev/null; then
  sudo apt-add-repository -y ppa:remmina-ppa-team/remmina-next
  sudo apt update -y
  sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
fi

