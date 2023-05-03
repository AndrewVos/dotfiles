#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

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

brew-install stow
brew-install wget
brew-install font-hack

brew-install-cask discord
brew-install-cask visual-studio-code

brew-tap homebrew/cask-drivers
brew-install-cask cameracontroller
