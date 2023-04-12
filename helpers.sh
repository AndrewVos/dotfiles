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
    cd="$1"
    if ! apt-installed "$cd"; then
        sudo apt install "$cd"
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

function add-line-to-file() {
    FILE="$1"
    LINE="$2"

    grep -qxF "$LINE" "$FILE" || echo "$LINE" >>"$FILE"
}

function sudo-add-line-to-file() {
    FILE="$1"
    LINE="$2"

    file-has-line "$FILE" "$LINE" || echo "$LINE" | sudo tee -a "$FILE"
}
