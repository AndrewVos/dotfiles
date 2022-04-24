#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo systemctl enable ly.service ||:

sudo systemctl enable --now postgresql ||:
sudo systemctl enable --now sshd ||:
