#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
source ./helpers.sh

apt-install postgresql
apt-install postgresql-contrib
apt-install libpq-dev

sudo su postgres -c "createuser -s $USER" || :
