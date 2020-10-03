#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

ADDED_SUPERUSER_PATH="$HOME/.initialized-postgres"

if [[ ! -f "$ADDED_SUPERUSER_PATH" ]]; then
  sudo su postgres -c "initdb --locale $LANG -E UTF8 -D /var/lib/postgres/data"
  sudo systemctl enable --now postgresql
  sudo su postgres -c "createuser -s $USER"
  touch "$ADDED_SUPERUSER_PATH"
fi
