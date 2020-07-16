#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
