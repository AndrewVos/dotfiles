#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "webtorrent-desktop" &> /dev/null; then
  sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    keyboard-configuration \
    wget
  sudo apt install -y libcanberra-gtk-module libcanberra-gtk3-module


  wget "https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.23.0/webtorrent-desktop_0.23.0_amd64.deb" -O /tmp/webtorrent.deb
  sudo apt install -y /tmp/webtorrent.deb
fi
