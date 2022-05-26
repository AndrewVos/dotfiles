#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if laptop-detect; then
  xrdb -merge "$HOME/.Xresources.laptop"
fi

picom &

conky --config ~/.config/conky/time.conf &
if laptop-detect; then
  conky --pause 5 --config ~/.config/conky/battery.conf &
fi

redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"') &

xmousepasteblock &
hsetroot -solid '#24283b' &
xsetroot -cursor_name left_ptr &
unclutter --timeout 1 &
enpass &
dunst &

if [[ $(hostnamectl hostname) = "desktop" ]]; then
  # stop autofocusing the camera
  v4l2-ctl \
    --media-bus-info usb-0000:00:14.0-2 \
    --device "HD Pro Webcam C920" \
    --set-ctrl focus_auto=0 &

  # delay shutting down the monitor
  xset s 3600 3600 &
  xset -dpms &
fi
