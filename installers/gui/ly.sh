#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "ly" &> /dev/null; then
  git clone https://github.com/nullgemm/ly
  cd ly
  make github
  make
  sudo make install
  sudo systemctl disable gdm.service
  sudo systemctl enable ly.service
fi
