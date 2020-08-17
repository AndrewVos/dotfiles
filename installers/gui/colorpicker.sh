#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "colorpicker" &> /dev/null; then
  sudo apt-get install -y git make pkg-config gcc libgtk2.0-dev
  git clone https://github.com/Ancurio/colorpicker
  cd colorpicker
  make
fi
