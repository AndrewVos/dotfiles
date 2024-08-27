#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
source ./helpers.sh

apt-install git
apt-install curl
apt-install stow
apt-install fonts-hack-ttf
apt-install gnome-tweaks
snap-install-classic code
snap-install discord
snap-install bruno

if ! apt-installed "enpass"; then
    sudo-add-line-to-file "/etc/apt/sources.list.d/enpass.list" "deb https://apt.enpass.io/ stable main"
    if [[ ! -f " /etc/apt/trusted.gpg.d/enpass.asc" ]]; then
        wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo tee /etc/apt/trusted.gpg.d/enpass.asc
    fi
    sudo apt update -y
    apt-install enpass
fi
