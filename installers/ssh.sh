#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! systemctl status sshd; then
  sudo systemctl enable sshd ||:
  sudo systemctl start sshd ||:
fi
