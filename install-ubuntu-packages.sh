#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
source ./helpers.sh

apt-install git
apt-install curl
apt-install stow
apt-install fonts-hack-ttf
snap-install-classic code
snap-install enpass
