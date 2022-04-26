#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

INITIALIZED_POSTGRES="$HOME/.initialized-postgres"

if [[ ! -f "$INITIALIZED_POSTGRES" ]]; then
  sudo su postgres -c "initdb --locale $LANG -E UTF8 -D /var/lib/postgres/data"
  sudo su postgres -c "createuser -s $USER"
  echo "timezone='UTC'" | sudo tee -a /var/lib/postgres/data/postgresql.conf
  touch "$INITIALIZED_POSTGRES"
fi
