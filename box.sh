#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function bootstrap-box () {
  # shellcheck source=/dev/null
  source <(curl -s https://raw.githubusercontent.com/AndrewVos/box/master/box.sh)
}

if [[ -f "$HOME/code/box/box.sh" ]]; then
  # shellcheck source=../code/box/box.sh
  source "$HOME/code/box/box.sh"
else
  bootstrap-box
fi

sudo apt update -y -qqq
sudo apt upgrade -y -qqq

section "dependencies"
  satisfy apt "git"
  satisfy apt "curl"
  satisfy apt "wget"
  satisfy apt "make"
end-section

section "databases"
  satisfy apt "pgcli"
  section "postgres"
    satisfy apt "postgresql"
    if did-install; then
      sudo su postgres -c "createuser -s $USER"
    fi
  end-section
  satisfy apt "libpq-dev"
  satisfy apt "redis"
end-section

section "programming languages"
  section "nodejs"
    function install-nvm () {
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
    }
    satisfy file "nvm" "$HOME/.nvm/nvm.sh"
  end-section

  function install-yarn() {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    sudo apt-get update -y
    sudo apt-get install -y yarn
  }
  satisfy executable "yarn"

  section "ruby"
    function install-ruby-install() {
      wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
      tar -xzvf ruby-install-0.7.0.tar.gz
      cd ruby-install-0.7.0/
      sudo make install
    }
    satisfy executable "ruby-install"

    function install-chruby() {
      wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
      tar -xzvf chruby-0.3.9.tar.gz
      cd chruby-0.3.9/
      sudo make install
    }
    satisfy file "chruby" "/usr/local/share/chruby/chruby.sh"
  end-section

  section "golang"
    section "golang"
      satisfy file-line "Add go binaries to PATH" ~/.bashrc 'export PATH="$PATH:/usr/local/go/bin"'
      satisfy file-line "Export GOPATH" ~/.bashrc 'export GOPATH="$HOME/gopath"'
      satisfy file-line "Add go package binaries to PATH" ~/.bashrc 'export PATH="$GOPATH/bin:$PATH"'
      export PATH="$PATH:/usr/local/go/bin"
      satisfy golang "go1.14"
    end-section
  end-section
end-section

section "apps"
  satisfy apt "htop"
  satisfy apt "shellcheck"
  satisfy apt "krita"
  satisfy apt "xclip"
  satisfy apt "tig"

  function install-hugo() {
    wget https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-64bit.tar.gz -O hugo.tar.gz
    tar -xzvf hugo.tar.gz
    sudo cp hugo /usr/local/bin/hugo
  }
  satisfy executable "hugo"

  function install-heroku() {
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
  }
  satisfy executable "heroku"

  function install-google-chrome-stable() {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
    sudo apt install -y ./chrome.deb
  }
  satisfy executable "google-chrome-stable"

  function install-slack() {
    wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.3-amd64.deb -O slack.deb
    sudo apt install -y ./slack.deb
  }
  satisfy executable "slack"

  function install-spotify() {
    curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
    if [[ ! -f /etc/apt/sources.list.d/spotify.list ]]; then
      echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    fi

    sudo apt-get update -y
    sudo apt install -y spotify-client
  }
  satisfy executable "spotify"

  if [[ ! -f /opt/enpass/Enpass ]]; then
    wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo apt-key add -
    echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
    sudo apt-get update -y
    sudo apt install -y enpass
  fi

  function install-webtorrent-desktop() {
    wget "https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.20.0/webtorrent-desktop_0.20.0-1_amd64.deb" -O webtorrent.deb
    sudo apt install -y ./webtorrent.deb
  }
  satisfy executable "webtorrent-desktop"

  satisfy apt "mpv"
  satisfy apt "whois"
  satisfy apt "jq"

  function install-discord() {
    wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O discord.deb
    sudo apt install -y ./discord.deb
  }
  satisfy executable "discord"

  satisfy apt "flameshot"

  function install-ngrok() {
    wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O ngrok.zip
    unzip ngrok.zip
    sudo cp ngrok /usr/local/bin/ngrok
  }
  satisfy executable "ngrok"

  function install-exa() {
    wget https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip -O exa.zip
    unzip exa.zip
    sudo cp exa-linux-x86_64 /usr/local/bin/exa
  }
  satisfy executable "exa"

  section "fzy"
    satisfy apt "fzy"
  end-section

  section "vim"
    satisfy apt "vim-gtk3"

    section "ctags"
      satisfy apt "autoconf"
      satisfy apt "pkg-config"
      satisfy apt "gcc"
      satisfy apt "pkg-config"
      satisfy apt "automake"
      satisfy apt "python3-docutils"
      satisfy apt "libseccomp-dev"
      satisfy apt "libjansson-dev"
      satisfy apt "libyaml-dev"
      satisfy apt "libxml2-dev"

      function install-ctags() {
        git clone https://github.com/universal-ctags/ctags
        cd ctags
        ./autogen.sh
        ./configure
        make
        sudo make install
      }
      satisfy executable "ctags"
    end-section

    PLUGINS="
tpope/vim-pathogen
tpope/vim-sleuth
tpope/vim-sensible
tpope/vim-unimpaired
tpope/vim-surround
tpope/vim-commentary
tpope/vim-fugitive
tpope/vim-vinegar
tpope/vim-jdaddy
pangloss/vim-javascript
jamessan/vim-gnupg
mattn/webapi-vim
vim-scripts/Gist.vim
AndrewVos/vim-aaa
AndrewVos/vim-ring
FooSoft/vim-argwrap
airblade/vim-gitgutter
dietsche/vim-lastplace
stefandtw/quickfix-reflector.vim
ntpeters/vim-better-whitespace
tpope/vim-eunuch
tpope/vim-abolish
int3/vim-extradite
tpope/vim-speeddating
Chiel92/vim-autoformat
terryma/vim-multiple-cursors
ap/vim-css-color
elixir-lang/vim-elixir
tpope/vim-rhubarb
kopischke/vim-fetch
kristijanhusak/vim-js-file-import
jeffkreeftmeijer/vim-dim
godlygeek/tabular
AndrewRadev/sideways.vim
mhinz/vim-startify
tpope/vim-haystack
AndrewVos/vim-git-navigator
"
    for PLUGIN in $PLUGINS; do
      PLUGIN_NAME=$(echo "$PLUGIN" | cut -d "/" -f 2)
      satisfy github "https://github.com/$PLUGIN" "$HOME/.vim/bundle/$PLUGIN_NAME"
    done

    # generate docs
    vim -c Helptags -c q
  end-section

  section "hub"
    function install-hub () {
      wget -O hub.tgz "https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz"
      tar -xvzf hub.tgz
      sudo cp "hub-linux-amd64-2.3.0-pre10/bin/hub" "/usr/local/bin/hub"
    }
    satisfy executable "hub"
  end-section
end-section

section "dotfiles"
  satisfy github "https://github.com/AndrewVos/dotfiles" "$HOME/.dotfiles"
  satisfy apt "stow"
  stow --verbose --dir "$HOME/.dotfiles" --target ~ bash ctags git ssh vim
  satisfy file-line "Source bash init.sh" ~/.bashrc "source ~/.dotfiles/bash/init.sh"
end-section
