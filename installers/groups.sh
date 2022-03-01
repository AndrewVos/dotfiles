#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# power: shutdown and reboot
# video: control screen brightness
# nordvpn: control nordvpn

sudo usermod -a -G power,video,nordvpn "$USER"
