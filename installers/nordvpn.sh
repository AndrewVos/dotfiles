#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

nordvpn whitelist add subnet 192.168.1.1/24 ||:
