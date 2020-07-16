#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

for file in $(ls packs); do
  ./packs/$file
done
