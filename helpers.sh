#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

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

function brew-installed() {
    PACKAGE="$1"
    brew list "$PACKAGE" >/dev/null 2>&1
}

function brew-tapped() {
    TAP="$1"
    brew tap | grep -qxF "$TAP"
}

function brew-tap() {
    TAP="$1"
    brew-tapped "$TAP" || brew tap "$TAP"
}

function brew-install() {
    PACKAGE="$1"
    brew-installed "$PACKAGE" || brew install "$PACKAGE"
}

function brew-install-cask() {
    PACKAGE="$1"
    brew-installed "$PACKAGE" || brew install --cask "$PACKAGE"
}
