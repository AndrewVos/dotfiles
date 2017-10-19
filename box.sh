#!/bin/bash

function bootstrap-box () {
  local BOX_PATH="/usr/local/share/box/box.sh"
  if [ ! -f "$BOX_PATH" ]; then
    sudo mkdir -p "$(dirname "$BOX_PATH")"
    sudo wget -O "$BOX_PATH" https://raw.githubusercontent.com/AndrewVos/box/master/box.sh
    sudo chmod +x "$BOX_PATH"
  fi
  source "$BOX_PATH"
}

if [[ -f "$HOME/code/box/box.sh" ]]; then
  source "$HOME/code/box/box.sh"
else
  bootstrap-box
fi

section "dependencies"
  satisfy apt "git"
  satisfy apt "curl"
end-section

section "dotfiles"
  DOTFILES_PATH="$HOME/.dotfiles"
  satisfy github "https://github.com/AndrewVos/dotfiles" "$DOTFILES_PATH"
  satisfy symlink "$DOTFILES_PATH/bash/.inputrc"        "$HOME/.inputrc"
  satisfy symlink "$DOTFILES_PATH/git/.git-template"    "$HOME/.git-template"
  satisfy symlink "$DOTFILES_PATH/git/.gitconfig"       "$HOME/.gitconfig"
  satisfy symlink "$DOTFILES_PATH/git/.gitignore"       "$HOME/.gitignore"
  satisfy symlink "$DOTFILES_PATH/screen/.screenrc"     "$HOME/.screenrc"
  satisfy symlink "$DOTFILES_PATH/ssh/.ssh/config"      "$HOME/.ssh/config"
  satisfy symlink "$DOTFILES_PATH/tarsnap/.tarsnaprc"   "$HOME/.tarsnaprc"
  satisfy symlink "$DOTFILES_PATH/fish"                 "$HOME/.config/fish"
  satisfy symlink "$DOTFILES_PATH/tmux/.tmux.conf"      "$HOME/.tmux.conf"

  satisfy file-line "Add dotfiles scripts to PATH" ~/.bashrc "export PATH=\$PATH:$DOTFILES_PATH/scripts"
  satisfy file-line "Setup ssh-agent" ~/.bashrc "source $DOTFILES_PATH/bash/ssh-agent.sh"
  satisfy file-line "Setup gpg-agent" ~/.bashrc "source $DOTFILES_PATH/bash/gpg-agent.sh"
  satisfy file-line "Use custom PS1" ~/.bashrc "source $DOTFILES_PATH/bash/ps1.sh"
  satisfy file-line 'Source secrets in .bashrc' ~/.bashrc 'source ~/.secrets/bash'
end-section

section "bash"
  section "miscellaneous"
    satisfy file-line "Store a long bash history" ~/.bashrc "HISTSIZE=100000; HISTFILESIZE=2000000"
  end-section

  section "aliases"
    satisfy file-line "Alias g to git" ~/.bashrc "alias g=git"
    satisfy file-line "Setup g to use git completions" ~/.bashrc "complete -o default -o nospace -F _git g"
    satisfy file-line "Source git completions" ~/.bashrc "source /usr/share/bash-completion/completions/git"
    satisfy file-line "Alias b" ~/.bashrc "alias b='bundle exec'"
    satisfy file-line "Alias ber" ~/.bashrc "alias ber='bundle exec rspec spec --color'"
    satisfy file-line "Alias bec" ~/.bashrc "alias bec='bundle exec cucumber --color'"
    satisfy file-line "Alias irb to pry" ~/.bashrc "alias irb=pry"
    satisfy file-line "Alias ls to show color" ~/.bashrc "alias ls='ls -1 -G --color=auto'"
    satisfy file-line "Alias ll" ~/.bashrc "alias ll='ls -ahlF --color=auto'"
  end-section
end-section

section "services"
  section "postgres"
    satisfy apt "postgresql"
    if did-install; then
      sudo su postgres -c "createuser -s $USER"
    fi
    satisfy apt "libpq-dev"
  end-section
  satisfy apt "redis-server"
end-section

satisfy apt "awscli"

section "VPN"
  satisfy apt "openvpn"
  satisfy apt "network-manager-openvpn-gnome"

  section "l2tp"
    satisfy apt-ppa "ppa:nm-l2tp/network-manager-l2tp"
    satisfy apt "strongswan"
    satisfy apt "network-manager-strongswan"
    satisfy apt "network-manager-l2tp"
    satisfy apt "network-manager-l2tp-gnome"
  end-section
end-section

section "phantomjs"
  function install-phantomjs () {
    wget "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2"
    bzip2 -d "phantomjs-2.1.1-linux-x86_64.tar.bz2"
    tar -xf "phantomjs-2.1.1-linux-x86_64.tar"
    sudo cp "phantomjs-2.1.1-linux-x86_64/bin/phantomjs" "/usr/local/bin/phantomjs"
  }
  satisfy executable "phantomjs"
end-section

section "programming languages"
  section "nodejs"
    if must-install apt "nodejs"; then
      sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 68576280
      sudo apt-add-repository "deb https://deb.nodesource.com/node_8.x $(lsb_release -sc) main"
      sudo apt-get update
    fi
    satisfy apt "nodejs"
    satisfy file-line "Add node_modules bin to PATH" ~/.bashrc 'export PATH="$PATH:node_modules/.bin"'

    function install-npm () {
      npm install -g npm
    }
    satisfy executable "npm"

    if must-install apt "yarn"; then
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
      sudo apt-get update
    fi
    satisfy apt "yarn"
    satisfy file-line 'Add yarn binaries to PATH' ~/.bashrc 'export PATH=$PATH:~/.yarn/bin'
  end-section

  section "ruby"
    section "chruby"
      function install-chruby () {
	wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
	tar -xzvf chruby-0.3.9.tar.gz
	cd chruby-0.3.9/
	sudo make install
	set +u
	. /usr/local/share/chruby/chruby.sh
	set -u
      }
      satisfy file "chruby" "/usr/local/share/chruby/chruby.sh"
      satisfy file-line "Source chruby" ~/.bashrc "source /usr/local/share/chruby/chruby.sh"
      satisfy file-line "Source chruby-auto" ~/.bashrc "source /usr/local/share/chruby/auto.sh"
    end-section

    section "ruby-install"
      function install-ruby-install () {
	wget -O ruby-install-0.6.1.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz
	tar -xzvf ruby-install-0.6.1.tar.gz
	cd ruby-install-0.6.1/
	sudo make install
      }
      satisfy executable "ruby-install"
    end-section

    section "ruby-2.3.0"
      function install-ruby-2-3-0 () {
	ruby-install ruby-2.3.0
      }
      satisfy file "ruby-2.3.0" "$HOME/.rubies/ruby-2.3.0/bin/ruby"
    end-section

    section "ruby-2.3.3"
      function install-ruby-2-3-3 () {
	ruby-install ruby-2.3.3
      }
      satisfy file "ruby-2.3.3" "$HOME/.rubies/ruby-2.3.3/bin/ruby"
    end-section

    section "ruby 2.4.1"
      function install-ruby-2-4-1 () {
	ruby-install ruby-2.4.1
      }
      satisfy file "ruby-2.4.1" "$HOME/.rubies/ruby-2.4.1/bin/ruby"
    end-section
  end-section

  section "golang"
    satisfy file-line "Add go binaries to PATH" ~/.bashrc 'export PATH="$PATH:/usr/local/go/bin"'
    satisfy file-line "Export GOPATH" ~/.bashrc 'export GOPATH="$HOME/gopath"'
    satisfy file-line "Add go package binaries to PATH" ~/.bashrc 'export PATH="$GOPATH/bin:$PATH"'
    export PATH="$PATH:/usr/local/go/bin"
    satisfy golang "go1.9"
  end-section
end-section

section "terminal colours"
  function install-chalk () {
    wget -O "$HOME/.chalk.sh" http://git.io/v3Dlb
    chmod +x "$HOME/.chalk.sh"
    $HOME/.chalk.sh
  }
  satisfy file "chalk" "$HOME/.chalk.sh"
end-section

section "cli tools"
  satisfy apt "htop"
  satisfy apt "shellcheck"
  satisfy apt "tmate"

  section "tmux"
    satisfy apt "tmux"
    satisfy file-line "Launch tmux in new shells" ~/.bashrc '[[ "$-" = *i* ]] && [[ -z "$TMUX" ]] && exec tmux'
  end-section

  section "tarsnap"
    function install-tarsnap () {
      wget -O tarsnap.tgz https://www.tarsnap.com/download/tarsnap-autoconf-1.0.39.tgz
      tar -zxvf tarsnap.tgz
      cd tarsnap-autoconf-1.0.39
      ./configure
      make all
      sudo make install
    }
    satisfy apt "e2fslibs-dev"
    satisfy executable "tarsnap"
  end-section

  section "vim"
    function install-vim () {
      sudo apt install xorg-dev ncurses-dev

      git clone https://github.com/vim/vim.git --depth 1
      cd vim
      ./configure --enable-pythoninterp
      make
      sudo make install
    }
    satisfy executable "vim"
    satisfy file-line "Make vim the default EDITOR" ~/.bashrc 'export EDITOR=vim'
    satisfy apt "exuberant-ctags"

    satisfy github "https://github.com/AndrewVos/vimfiles" "$HOME/.vimfiles"
    satisfy symlink "$HOME/.vimfiles/.vimrc" "$HOME/.vimrc"
    satisfy symlink "$HOME/.vimfiles/.vim" "$HOME/.vim"
    (cd "$HOME/.vimfiles" && ./plugins.sh)
  end-section

  section "micro"
    function install-micro () {
      sudo snap install micro --edge --classic
    }
    satisfy executable "micro"
  end-section

  section "hub"
    function install-hub () {
      wget -O hub.tgz "https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz"
      tar -xvzf hub.tgz
      sudo cp "hub-linux-amd64-2.3.0-pre10/bin/hub" "/usr/local/bin/hub"
    }
    satisfy executable "hub"
  end-section

  section "ngrok"
    function install-ngrok () {
      wget -O ngrok.zip "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip"
      unzip ngrok.zip
      chmod +x ngrok
      sudo mv ngrok /usr/local/bin/ngrok
    }
    satisfy executable "ngrok"
  end-section

  section "heroku"
    function install-heroku () {
      wget https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-linux-x64.tar.gz -O heroku.tar.gz
      tar -xzf heroku.tar.gz
      sudo mv heroku-cli-v6.14.35-e0fe5a3-linux-x64 /usr/local/lib/heroku
      sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku
    }
    satisfy executable "heroku"
  end-section

  section "terraform"
    function install-terraform () {
      wget -O terraform.zip https://releases.hashicorp.com/terraform/0.10.7/terraform_0.10.7_linux_amd64.zip
      unzip terraform.zip
      sudo mv terraform /usr/local/bin/terraform
    }
    satisfy executable "terraform"
  end-section
end-section

section "apps"
  section "gimp"
    satisfy apt "gimp"
  end-section

  section "chrome"
    satisfy deb google-chrome-stable "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  end-section

  section "peek"
    satisfy apt-ppa "ppa:peek-developers/stable"
    satisfy apt "peek"
  end-section

  section "webtorrent"
    satisfy apt "gconf2"
    satisfy deb "webtorrent-desktop" "https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.18.0/webtorrent-desktop_0.18.0-1_amd64.deb"
  end-section

  section "slack"
    satisfy deb "slack-desktop" "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.7.1-amd64.deb"
  end-section

  section "discord"
    satisfy apt "libc++1"
    satisfy deb "discord" "https://discordapp.com/api/download?platform=linux&format=deb"
  end-section

  section "spotify"
    if must-install apt "spotify-client"; then
      sudo apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-keys "BBEBDCB318AD50EC6865090613B00F1FD2C19886" "0DF731E45CE24F27EEEB1450EFDC8610341D9410"
      echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

      sudo apt-get -y update
    fi
    satisfy apt "spotify-client"
  end-section

  section "enpass"
    if must-install apt "enpass"; then
      echo "deb http://repo.sinew.in/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
      wget -O - https://dl.sinew.in/keys/enpass-linux.key | sudo apt-key add -
      sudo apt update
    fi
    satisfy apt "enpass"
  end-section
end-section

section "settings"
  satisfy dconf "Take a screenshot with CMD+SHIFT+s" "org.gnome.settings-daemon.plugins.media-keys" "area-screenshot-clip" "<Shift><Super>s"
  satisfy dconf "Launch terminal with CMD+t" "org.gnome.settings-daemon.plugins.media-keys" "terminal" "<Super>t"
  satisfy dconf "Caps Lock acts as Ctrl" "org.gnome.desktop.input-sources" "xkb-options" "['caps:ctrl_modifier']"
  satisfy dconf "Enable hot corners" "org.gnome.shell" "enable-hot-corners" true
  satisfy dconf "Remove minimize and maximize" "org.gnome.desktop.wm.preferences" "button-layout" ":close"
  satisfy dconf "Hide desktop icons" "org.gnome.desktop.background" "show-desktop-icons" "false"
end-section

section "fonts"
  satisfy apt "fonts-hack-ttf"
end-section
