#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "google-chrome-stable" &> /dev/null; then
  sudo apt install -y wget
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
  sudo apt install -y /tmp/chrome.deb
fi
