#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! systemctl status sshd; then
  sudo systemctl enable --now sshd ||:
fi
