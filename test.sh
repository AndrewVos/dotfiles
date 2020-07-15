#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo docker build -t dotfiles-tests .

mkdir -p /tmp/dotfiles-test-output

for file in $(ls apps); do
  MD5=$(md5sum apps/$file)
  if [[ ! "$MD5" = "$(cat /tmp/dotfiles-test-output/$file ||:)" ]]; then
    echo "--------------------> $file <--------------------"
    echo
    sudo docker run --env USER=root --env UPGRADE=no -it --rm dotfiles-tests "/app/apps/$file"
    md5sum "apps/$file" > /tmp/dotfiles-test-output/$file
  fi
done
