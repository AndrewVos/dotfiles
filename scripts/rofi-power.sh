#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

OPTIONS="Shutdown\nReboot\nLogout"

option=`echo -e $OPTIONS | awk '{print $1}' | tr -d '\r\n\t'`
if [ "$@" ]; then
  case $@ in
    *Shutdown)
      shutdown now
      ;;
    *Reboot)
      reboot
      ;;
    *Logout)
      bspc quit
      ;;
  esac
else
  echo -e $OPTIONS
fi
