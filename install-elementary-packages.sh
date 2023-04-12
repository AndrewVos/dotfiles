#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function apt-installed() {
    PACKAGE=$1
    dpkg-query -W -f='${Status}' "$PACKAGE" 2>/dev/null | grep "ok installed" --silent
}

function snap-installed() {
    PACKAGE=$1
    snap info "$PACKAGE" 2>/dev/null | grep "installed:" --silent
}

function apt-install() {
    PACKAGE="$1"
    if ! apt-installed "$PACKAGE"; then
        sudo apt install "$PACKAGE"
    fi
}

function apt-install-deb() {
    PACKAGE="$1"
    URL="$2"

    if ! apt-installed "$PACKAGE"; then
        FILE_PATH="$PACKAGE.deb"

        wget -O "$FILE_PATH" "$URL"
        sudo dpkg -i "$FILE_PATH"
        rm "$FILE_PATH"
    fi
}

function snap-install() {
    PACKAGE="$1"
    if ! snap-installed "$PACKAGE"; then
        sudo snap install "$PACKAGE"
    fi
}

function snap-install-classic() {
    PACKAGE="$1"
    if ! snap-installed "$PACKAGE"; then
        sudo snap install "$PACKAGE" --classic
    fi
}

function apt-uninstall() {
    PACKAGE="$1"
    if apt-installed "$PACKAGE"; then
        sudo apt remove "$PACKAGE"
    fi
}

function file-has-line() {
    FILE="$1"
    LINE="$2"

    grep -qxF "$LINE" "$FILE"
}

function sudo-add-line-to-file() {
    FILE="$1"
    LINE="$2"

    file-has-line "$FILE" "$LINE" || echo "$LINE" | sudo tee -a "$FILE"
}

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
