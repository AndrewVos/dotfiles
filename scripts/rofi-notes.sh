#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

set +u
CHOICE="$1"
set -u

if [[ "$CHOICE" != "" ]]; then
  coproc abricotine "$HOME/.notes/$CHOICE"
  exec 1>&-
  exit;
 else
  cd "$HOME/.notes"
  find . -type f -name "*.md" | cut -c 3- | sort
fi
