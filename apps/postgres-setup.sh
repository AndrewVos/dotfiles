#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y postgresql libpq-dev
ADDED_SUPERUSER_PATH="$HOME/.added-postgres-superuser"

if [[ ! -f "$ADDED_SUPERUSER_PATH" ]]; then
  sudo service postgresql start
  sudo su postgres -c "createuser -s $USER"
  touch "$ADDED_SUPERUSER_PATH"
fi
