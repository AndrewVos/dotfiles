#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

OPTIONS=(
Chrome
"Chrome incognito"
Slack
Enpass
Discord
Krita
"Colour Picker"
Spotify
)

NORDVPN_STATUS=$(nordvpn status | awk '{print $4}')
if [[ "$NORDVPN_STATUS" = "Disconnected" ]]; then
  OPTIONS+=('Connect to VPN')
else
  OPTIONS+=('Disconnect from VPN')
fi

function run_command() {
  $@ > /dev/null 2>&1 &
}

if [ "$@" ]; then
  command="$@"

  if [[ "$command" = "Chrome" ]]; then
    run_command google-chrome-stable chrome-search://local-ntp/local-ntp.html
  elif [[ "$command" = "Chrome incognito" ]]; then
    run_command google-chrome-stable --incognito chrome-search://local-ntp/local-ntp.html
  elif [[ "$command" = "Slack" ]]; then
    run_command slack
  elif [[ "$command" = "Enpass" ]]; then
    run_command enpass
  elif [[ "$command" = "Discord" ]]; then
    run_command discord
  elif [[ "$command" = "Krita" ]]; then
    run_command krita
  elif [[ "$command" = "Colour Picker" ]]; then
    run_command pick-colour-picker
  elif [[ "$command" = "Connect to VPN" ]]; then
    run_command nordvpn connect
  elif [[ "$command" = "Disconnect from VPN" ]]; then
    run_command nordvpn disconnect
  fi
else
  for option in "${OPTIONS[@]}"; do
    echo "$option"
  done
fi

