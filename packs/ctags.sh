#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

command -v ctags && exit 0

sudo apt install -y exuberant-ctags
