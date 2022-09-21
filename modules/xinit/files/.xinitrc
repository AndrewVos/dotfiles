#!/bin/sh

if laptop-detect; then
  xrdb -merge "$HOME/.Xresources.laptop"
fi

if [[ $(hostnamectl hostname) = "desktop" ]]; then
  # stop autofocusing the camera
  v4l2-ctl \
    --media-bus-info usb-0000:00:14.0-2 \
    --device "HD Pro Webcam C920" \
    --set-ctrl focus_auto=0

  # delay shutting down the monitor
  xset s 3600 3600
  xset -dpms
  
  xrdb -merge "$HOME/.Xresources.desktop"
fi

redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"') &
picom --experimental-backends &
xmousepasteblock &
unclutter --timeout 1 &
dunst &

exec awesome
