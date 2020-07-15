#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

set -x

sudo lxc delete vim-test --force ||:
sudo lxc launch ubuntu:20.04 vim-test
sudo lxc file push packs/vim.sh vim-test/
sleep 5
sudo lxc exec vim-test -- /vim.sh
