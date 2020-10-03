#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$UPGRADE" = "yes" ]]; then
  asdf update
  asdf plugin update --all
fi
