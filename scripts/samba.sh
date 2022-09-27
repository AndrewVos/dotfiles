#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo docker stop samba ||:
sudo docker rm samba ||:
sudo docker run -it --name samba -p 139:139 -p 445:445 \
  -v /home/media/share:/mount \
  -d dperson/samba \
  -u "media;media" \
  -s "share;/mount;yes;no"\
  -p

