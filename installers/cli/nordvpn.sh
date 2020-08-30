#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo systemctl start nordvpnd.service
sudo systemctl enable nordvpnd.service
nordvpn whitelist add subnet 192.168.1.1/24 ||:
