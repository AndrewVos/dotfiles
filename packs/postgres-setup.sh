#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y postgresql libpq-dev

if [[ ! -f ~/.added-postgres-superuser ]]; then
  sudo service postgresql start
  sudo su postgres -c "createuser -s $USER"
  touch ~/.added-postgres-superuser
fi
