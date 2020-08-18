#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function github-cli-latest-url() {
  curl -s https://api.github.com/repos/cli/cli/releases/latest \
    | grep browser_download_url \
    | grep linux_amd64.deb \
    | cut -d '"' -f 4
}


function install-latest-github-cli() {
  sudo apt install -y curl wget

  LATEST_GITHUB_CLI_VERSION="$(github-cli-latest-url)"
  INSTALLED_GITHUB_CLI_VERSION="$(cat "$HOME/.installed-github-cli-version" || :)"

  echo "|||$LATEST_GITHUB_CLI_VERSION|||"
  if [[ "$INSTALLED_GITHUB_CLI_VERSION" != "$LATEST_GITHUB_CLI_VERSION" ]]; then
    wget -O /tmp/github-cli.deb "$LATEST_GITHUB_CLI_VERSION"
    sudo apt install -y /tmp/github-cli.deb
    echo "$LATEST_GITHUB_CLI_VERSION" > "$HOME/.installed-github-cli-version"
  fi
}

github-cli-latest-url
if ! command -v "gh" &> /dev/null; then
  install-latest-github-cli
elif [[ "$UPGRADE" = "yes" ]]; then
  install-latest-github-cli
fi
