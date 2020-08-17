#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y openssh-server

if ! systemctl status ssh; then
  sudo systemctl enable ssh ||:
  sudo systemctl start ssh ||:
fi
