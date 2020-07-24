#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y \
  whois \
  jq \
  fzy \
  git \
  curl \
  wget \
  make \
  pgcli \
  htop \
  shellcheck \
  exuberant-ctags \
  redis \
  tig
