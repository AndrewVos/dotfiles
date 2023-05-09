#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
source ./helpers.sh

brew-install stow
brew-install wget
brew-install font-hack

brew-install-cask discord
brew-install-cask visual-studio-code
brew install-cask tomatobar

brew-tap homebrew/cask-drivers
brew-install-cask cameracontroller
