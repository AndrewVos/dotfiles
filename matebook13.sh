#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo pacman -S acpi acpilight

sudo mkdir -p /etc/X11/xorg.conf.d

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

sudo tee <<'EOF' /etc/X11/xorg.conf.d/00-keyboard.conf 1> /dev/null
Section "InputClass"
  Identifier "system-keyboard"
  MatchIsKeyboard "on"
  Option "XkbLayout" "gb"
  Option "XkbModel" "pc104"
  Option "XkbOptions" "ctrl:nocaps"
EndSection
EOF

# /sys/class/backlight/amdgpu_bl0/brightness

sudo tee <<'EOF' /etc/udev/rules.d/90-backlight.rules 1> /dev/null
# Allow video group to control backlight and leds
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", \
  RUN+="/bin/chgrp video /sys/class/leds/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"
EOF
