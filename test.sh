#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo docker build -t dotfiles-tests .

mkdir -p /tmp/dotfiles-test-output
for file in $(ls packs); do
  MD5=$(md5sum packs/$file)
  if [[ "$MD5" != "$(cat /tmp/dotfiles-test-output/$file ||:)" ]]; then
    sudo docker run --env USER=root -it --rm dotfiles-tests "/app/packs/$file"
    md5sum "packs/$file" > /tmp/dotfiles-test-output/$file
  fi
done
