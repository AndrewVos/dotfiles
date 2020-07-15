#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

command -v ctags && exit 0

sudo apt install -y \
  autoconf \
  pkg-config \
  gcc \
  pkg-config \
  automake \
  python3-docutils \
  libseccomp-dev \
  libjansson-dev \
  libyaml-dev \
  libxml2-dev

CLONE_PATH=$(mktemp -d)

git clone https://github.com/universal-ctags/ctags "$CLONE_PATH"
cd "$CLONE_PATH"
./autogen.sh
./configure
make
sudo make install
