#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

killall conky ||:
conky --config /home/vos/.config/conky/time.conf &
if laptop-detect; then
  conky --config /home/vos/.config/conky/battery.conf &
fi

if [[ $(hostnamectl hostname) = "desktop" ]]; then
  # teams &
  # slack &
fi
