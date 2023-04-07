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

apt-install git
apt-install curl
apt-install snapd
apt-install stow
apt-uninstall io.elementary.code
snap-install-classic code
apt-install fonts-liberation
apt-install-deb "google-chrome-stable" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
snap-install discord
snap-install enpass
