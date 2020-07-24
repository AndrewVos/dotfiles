#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "slack" &> /dev/null; then
  sudo apt update -y
  sudo apt install -y wget
  sudo DEBIAN_FRONTEND=noninteractive apt install -y keyboard-configuration

  wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.3-amd64.deb -O /tmp/slack.deb
  sudo apt install -y /tmp/slack.deb
fi
