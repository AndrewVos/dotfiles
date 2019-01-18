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

sudo apt update -y
sudo apt upgrade -y

section "dependencies"
  satisfy apt "git"
  satisfy apt "curl"
  satisfy apt "wget"
  satisfy apt "make"
end-section

section "databases"
  section "postgres"
    satisfy apt "postgresql"
    if did-install; then
      sudo su postgres -c "createuser -s $USER"
    fi
  end-section
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
end-section

section "apps"
  satisfy apt "htop"
  satisfy apt "shellcheck"
  satisfy apt "krita"

  function install-heroku() {
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
  }
  satisfy executable "heroku"

  # reqired for chrome
  satisfy apt "fonts-liberation"
  function install-google-chrome-stable() {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
    sudo dpkg -i chrome.deb
  }
  satisfy executable "google-chrome-stable"

  # required for slack
  satisfy apt "gconf2"
  satisfy apt "gconf-service"
  satisfy apt "libappindicator1"
  function install-slack() {
    wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.3-amd64.deb -O slack.deb
    sudo dpkg -i slack.deb
  }
  satisfy executable "slack"

  function install-zoom() {
    wget https://zoom.us/client/latest/zoom_amd64.deb -O zoom.deb
    sudo apt install libxcb-xtest0
    sudo dpkg -i zoom.deb
  }
  satisfy executable "zoom"

  function install-spotify() {
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
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
    sudo dpkg -i webtorrent.deb
  }
  satisfy executable "webtorrent-desktop"

  satisfy apt "mpv"
  satisfy apt "whois"
  satisfy apt "jq"

  function install-discord() {
    sudo apt install -y "libc++1"
    wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O discord.deb
    sudo dpkg -i discord.deb
  }
  satisfy executable "discord"

  satisfy apt "python-pip"
  function install-cheat() {
    sudo pip install cheat
  }
  satisfy executable "cheat"

  satisfy apt "flameshot"

  section "vim"
    satisfy apt "vim-gtk3"

    section "ctags"
      satisfy apt "autoconf"
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

    satisfy github "https://github.com/AndrewVos/vimfiles" "$HOME/.vimfiles"
    satisfy symlink "$HOME/.vimfiles/.vimrc" "$HOME/.vimrc"
    satisfy symlink "$HOME/.vimfiles/.vim" "$HOME/.vim"
    (cd "$HOME/.vimfiles" && ./plugins.sh)
  end-section

  section "hub"
    function install-hub () {
      wget -O hub.tgz "https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz"
      tar -xvzf hub.tgz
      sudo cp "hub-linux-amd64-2.3.0-pre10/bin/hub" "/usr/local/bin/hub"
    }
    satisfy executable "hub"
  end-section

  section "chromedriver"
    function install-chromedriver () {
      wget "https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip"
      unzip "chromedriver_linux64.zip"
      sudo mv chromedriver /usr/local/bin/chromedriver
    }
    satisfy executable "chromedriver"
  end-section

end-section

section "dotfiles"
  satisfy github "https://github.com/AndrewVos/dotfiles" "$HOME/.dotfiles"
  satisfy apt "stow"
  stow --verbose --dir "$HOME/.dotfiles" --target ~ bash ctags git ssh
  satisfy file-line "Source bash init.sh" ~/.bashrc "source ~/.dotfiles/bash/init.sh"
end-section

section "fonts"
  FONT_HOME=~/.local/share/fonts

  function install-source-code-pro() {
    mkdir -p "$FONT_HOME/adobe-fonts/source-code-pro"

    git clone \
       --branch release \
       --depth 1 \
       'https://github.com/adobe-fonts/source-code-pro.git' \
       "$FONT_HOME/adobe-fonts/source-code-pro"

    fc-cache -f -v "$FONT_HOME/adobe-fonts/source-code-pro"
  }
  satisfy file "source-code-pro" "$FONT_HOME/adobe-fonts/source-code-pro/LICENSE.txt"
end-section
