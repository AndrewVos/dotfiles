#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# power: shutdown and reboot
# video: control screen brightness
# nordvpn: control nordvpn

function ensure_user_is_in_group() {
  GROUP=$1

  if id --name --groups --zero "$USER" | grep --quiet --null-data --line-regexp --fixed-strings "$GROUP"; then
      echo User \`$USER\' belongs to group \`$GROUP\'
  else
      echo User \`$USER\' does not belong to group \`$GROUP\'
      sudo usermod -a -G "$GROUP" "$USER"
  fi
}

ensure_user_is_in_group power
ensure_user_is_in_group video
ensure_user_is_in_group nordvpn
