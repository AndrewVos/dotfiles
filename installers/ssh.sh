#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! systemctl status sshd --no-pager; then
  sudo systemctl enable --now sshd ||:
fi
