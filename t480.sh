#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo pacman -S xorg-xbacklight

sudo mkdir -p /etc/X11/xorg.conf.d

sudo tee <<'EOF' /etc/X11/xorg.conf.d/00-keyboard.conf 1> /dev/null
Section "InputClass"
  Identifier "system-keyboard"
  MatchIsKeyboard "on"
  Option "XkbOptions" "ctrl:nocaps"
EndSection
EOF

sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
  Identifier "touchpad"
  MatchIsTouchpad "on"
  Driver "libinput"
  Option "NaturalScrolling" "on"
  Option "ScrollMethod" "twofinger"
  Option "ClickMethod" "clickfinger"
EndSection
EOF

sudo tee <<'EOF' /etc/X11/xorg.conf.d/20-intel.conf 1> /dev/null
Section "Device"
  Identifier  "Intel Graphics"
  Driver      "intel"
  Option      "Backlight"  "intel_backlight"
EndSection
EOF
