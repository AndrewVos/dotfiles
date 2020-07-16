#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "webtorrent-desktop" &> /dev/null; then
  cd $(mktemp -d)
  sudo apt install -y wget
  wget "https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.20.0/webtorrent-desktop_0.20.0-1_amd64.deb" -O /tmp/webtorrent.deb
  sudo apt install -y /tmp/webtorrent.deb
fi
