#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v "zsh" &> /dev/null; then
  sudo apt update -y
  sudo apt install -y zsh
fi
