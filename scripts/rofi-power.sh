#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

set +u
CHOICE="$1"
set -u

OPTIONS="Shutdown\nReboot\nLog out"

if [[ "$CHOICE" = "Shutdown" ]]; then
  systemctl poweroff
elif [[ "$CHOICE" = "Reboot" ]]; then
  systemctl reboot
elif [[ "$CHOICE" = "Log out" ]]; then
  bspc quit
else
  echo -e "$OPTIONS"
fi
