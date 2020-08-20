#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo mkdir -p /etc/X11/xorg.conf.d

sudo tee <<'EOF' /etc/X11/xorg.conf.d/00-keyboard.conf 1> /dev/null
Section "InputClass"
  Identifier "system-keyboard"
  MatchIsKeyboard "on"
  Option "XkbOptions" "ctrl:nocaps"
EndSection
EOF
