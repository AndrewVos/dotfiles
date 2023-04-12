#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

apt-install git
apt-install curl
apt-install snapd
apt-install stow
apt-uninstall io.elementary.code
snap-install-classic code
apt-install fonts-liberation
apt-install-deb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
snap-install discord

if ! apt-installed "enpass"; then
    sudo-add-line-to-file "/etc/apt/sources.list.d/enpass.list" "deb https://apt.enpass.io/ stable main"
    if [[ ! -f " /etc/apt/trusted.gpg.d/enpass.asc" ]]; then
        wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo tee /etc/apt/trusted.gpg.d/enpass.asc
    fi
    sudo apt update -y
    apt-install enpass
fi
