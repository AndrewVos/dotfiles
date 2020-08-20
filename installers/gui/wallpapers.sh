#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt-get install -y wget
mkdir -p "$HOME/.wallpapers"
wget https://i.imgur.com/Uss9jsw.jpg -O "$HOME/.wallpapers/Uss9jsw.jpg"
