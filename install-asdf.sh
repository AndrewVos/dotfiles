#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
source ./helpers.sh

if [ ! -d "$HOME/.asdf" ]; then
    git clone "https://github.com/asdf-vm/asdf.git" "$HOME/.asdf" --branch v0.11.3
fi

if [[ "$SHELL" = "/bin/bash" ]]; then
    add-line-to-file "$HOME/.bashrc" '. "$HOME/.asdf/asdf.sh"'
    add-line-to-file "$HOME/.bashrc" '. "$HOME/.asdf/completions/asdf.bash"'
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash"
elif [[ "$SHELL" = "/bin/zsh" ]]; then
    add-line-to-file "$HOME/.zshrc" '. "$HOME/.asdf/asdf.sh"'
    . "$HOME/.asdf/asdf.sh"
fi

# nodejs
asdf plugin list | grep --quiet nodejs || asdf plugin add nodejs
NODEJS_VERSION="19.8.1"
asdf list nodejs | grep --quiet "$NODEJS_VERSION" || asdf install nodejs "$NODEJS_VERSION"

# ruby requirements
apt-install autoconf
apt-install patch
apt-install build-essential
apt-install rustc
apt-install libssl-dev
apt-install libyaml-dev
apt-install libreadline-dev
apt-install zlib1g-dev
apt-install libgmp-dev
apt-install libncurses-dev
apt-install libffi-dev
apt-install libgdbm6t64
apt-install libgdbm-dev
apt-install libdb-dev
apt-install uuid-dev

# ruby
asdf plugin list | grep --quiet ruby || asdf plugin add ruby
RUBY_VERSION="3.3.0"
asdf list ruby | grep --quiet "$RUBY_VERSION" || asdf install ruby "$RUBY_VERSION"

# python requirements
apt-install build-essential
apt-install libssl-dev
apt-install zlib1g-dev
apt-install libbz2-dev
apt-install libreadline-dev
apt-install libsqlite3-dev
apt-install curl
apt-install libncurses-dev
apt-install xz-utils
apt-install tk-dev
apt-install libxml2-dev
apt-install libxmlsec1-dev
apt-install libffi-dev
apt-install liblzma-dev

# python
asdf plugin list | grep --quiet python || asdf plugin add python
PYTHON_VERSION="3.12.3"
asdf list python | grep --quiet "$PYTHON_VERSION" || asdf install python "$PYTHON_VERSION"
