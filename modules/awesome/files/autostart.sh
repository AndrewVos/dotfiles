#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

killall conky ||:
conky --config /home/vos/.config/conky/time.conf &
conky --config /home/vos/.config/conky/battery.conf &
