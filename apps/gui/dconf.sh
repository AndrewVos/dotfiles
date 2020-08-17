#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

dconf load / < "$HOME/.dotfiles/config.dconf"
