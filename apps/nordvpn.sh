#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "nordvpn" &> /dev/null; then
  wget -O nordvpn.deb "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb"
  sudo apt install -y ./nordvpn.deb
  sudo apt update -y
  sudo apt install -y nordvpn
  nordvpn whitelist add subnet 192.168.1.1/24
fi
