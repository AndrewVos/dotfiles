#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

BREW_FORMULAE_CACHE=""
BREW_CASKS_CACHE=""
BREW_FORMULAE_CACHE_LOADED=0
BREW_CASKS_CACHE_LOADED=0

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

function brew-formula-installed() {
    PACKAGE="$1"

    if [ "$BREW_FORMULAE_CACHE_LOADED" -eq 0 ]; then
        BREW_FORMULAE_CACHE="$(brew list --formula 2>/dev/null || true)"
        BREW_FORMULAE_CACHE_LOADED=1
    fi

    grep -qxF "$PACKAGE" <<<"$BREW_FORMULAE_CACHE"
}

function brew-cask-installed() {
    PACKAGE="$1"

    if [ "$BREW_CASKS_CACHE_LOADED" -eq 0 ]; then
        BREW_CASKS_CACHE="$(brew list --cask 2>/dev/null || true)"
        BREW_CASKS_CACHE_LOADED=1
    fi

    grep -qxF "$PACKAGE" <<<"$BREW_CASKS_CACHE"
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
    PACKAGES=("$@")
    MISSING=()

    for PACKAGE in "${PACKAGES[@]}"; do
        brew-formula-installed "$PACKAGE" || MISSING+=("$PACKAGE")
    done

    if [ "${#MISSING[@]}" -gt 0 ]; then
        brew install "${MISSING[@]}"
        BREW_FORMULAE_CACHE_LOADED=0
    fi
}

function brew-install-cask() {
    PACKAGES=("$@")
    MISSING=()

    for PACKAGE in "${PACKAGES[@]}"; do
        brew-cask-installed "$PACKAGE" || MISSING+=("$PACKAGE")
    done

    if [ "${#MISSING[@]}" -gt 0 ]; then
        brew install --cask "${MISSING[@]}"
        BREW_CASKS_CACHE_LOADED=0
    fi
}
