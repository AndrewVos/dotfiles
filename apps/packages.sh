#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt install -y \
  mpv \
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
  krita \
  xclip \
  tig \
  flameshot
