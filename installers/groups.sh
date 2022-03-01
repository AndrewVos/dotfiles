#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# power: shutdown and reboot
# video: control screen brightness

sudo usermod -a -G power,video "$USER"
