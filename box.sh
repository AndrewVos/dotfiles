function bootstrap-box () {
  local BOX_PATH="/usr/local/share/box/box.sh"
  if [ ! -f "$BOX_PATH" ]; then
    sudo mkdir -p `dirname "$BOX_PATH"`
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

satisfy apt "git"

DOTFILES_PATH="$HOME/dotfiles"
satisfy github "https://github.com/AndrewVos/dotfiles" "$DOTFILES_PATH"
satisfy symlink "$DOTFILES_PATH/bash/.inputrc"        "$HOME/.inputrc"
satisfy symlink "$DOTFILES_PATH/git/.git-template"    "$HOME/.git-template"
satisfy symlink "$DOTFILES_PATH/git/.gitconfig"       "$HOME/.gitconfig"
satisfy symlink "$DOTFILES_PATH/git/.gitignore"       "$HOME/.gitignore"
satisfy symlink "$DOTFILES_PATH/screen/.screenrc"     "$HOME/.screenrc"
satisfy symlink "$DOTFILES_PATH/ssh/.ssh/config"      "$HOME/.ssh/config"
satisfy symlink "$DOTFILES_PATH/tarsnap/.tarsnaprc"   "$HOME/.tarsnaprc"

satisfy file-line "Add dotfiles/scripts to PATH" ~/.bashrc 'export PATH=$PATH:~/dotfiles/scripts'
satisfy file-line "Setup ssh-agent" ~/.bashrc 'source $HOME/dotfiles/bash/ssh-agent.sh'
satisfy file-line "Setup gpg-agent" ~/.bashrc 'source $HOME/dotfiles/bash/gpg-agent.sh'

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

satisfy apt "nim"
satisfy file-line "Add nim bin to PATH" ~/.bashrc 'export PATH="/home/andrew/Nim/bin:$PATH"'

function install-hub () {
  wget -O hub.tgz "https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz"
  tar -xvzf hub.tgz
  sudo cp "hub-linux-amd64-2.3.0-pre10/bin/hub" "/usr/local/bin/hub"
}
satisfy executable "hub"

if must-install apt "enpass"; then
  sudo echo "deb http://repo.sinew.in/ stable main" > /etc/apt/sources.list.d/enpass.list
  wget -O - https://dl.sinew.in/keys/enpass-linux.key | sudo apt-key add -
  sudo apt update
fi
satisfy apt "enpass"

satisfy golang "go1.9"
satisfy file-line "Add go binaries to PATH" ~/.bashrc 'export PATH="$PATH:/usr/local/go/bin"'
satisfy file-line "Export GOPATH" ~/.bashrc 'export GOPATH="$HOME/gopath"'
satisfy file-line "Add go package binaries to PATH" ~/.bashrc 'export PATH="$GOPATH/bin:$PATH"'

satisfy file-line "Use custom PS1" ~/.bashrc "source $HOME/dotfiles/bash/ps1.sh"

# aliases
satisfy file-line "Alias g to git" ~/.bashrc "alias g=git"
satisfy file-line "Setup g to use git completions" ~/.bashrc "complete -o default -o nospace -F _git g"
satisfy file-line "Source git completions" ~/.bashrc "source /usr/share/bash-completion/completions/git"
satisfy file-line "Alias b" ~/.bashrc "alias b='bundle exec'"
satisfy file-line "Alias ber" ~/.bashrc "alias ber='bundle exec rspec spec --color'"
satisfy file-line "Alias bec" ~/.bashrc "alias bec='bundle exec cucumber --color'"
satisfy file-line "Alias irb to pry" ~/.bashrc "alias irb=pry"
satisfy file-line "Alias ls to show color" ~/.bashrc "alias ls='ls -1 -G --color=auto'"
satisfy file-line "Alias ll" ~/.bashrc "alias ll='ls -ahlF --color=auto'"

satisfy file-line "Store a long bash history" ~/.bashrc "HISTSIZE=100000; HISTFILESIZE=2000000"

satisfy github "https://github.com/AndrewVos/vimfiles" "$HOME/vimfiles"
satisfy symlink "$HOME/vimfiles/.vimrc" "$HOME/.vimrc"
satisfy symlink "$HOME/vimfiles/.vim" "$HOME/.vim"
(cd $HOME/vimfiles && ./plugins.sh)

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

function install-ruby-install () {
  wget -O ruby-install-0.6.1.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz
  tar -xzvf ruby-install-0.6.1.tar.gz
  cd ruby-install-0.6.1/
  sudo make install
}
satisfy executable "ruby-install"

function install-ruby-2-3-0 () {
  ruby-install ruby-2.3.0
}
satisfy file "ruby-2.3.0" "$HOME/.rubies/ruby-2.3.0/bin/ruby"

satisfy deb "slack-desktop" "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.7.1-amd64.deb"

satisfy apt "docker.io"

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

satisfy apt "curl"

if must-install apt "yarn"; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update
fi
satisfy apt "yarn"
satisfy file-line 'Add yarn binaries to PATH' ~/.bashrc 'export PATH=$PATH:~/.yarn/bin'

function install-discord () {
  wget -O discord.deb 'https://discordapp.com/api/download?platform=linux&format=deb'
  sudo dpkg -i discord.deb
}
satisfy executable "discord"

satisfy apt "postgresql"
if did-install; then
  sudo su postgres -c "createuser -s $USER"
fi
satisfy apt "libpq-dev"

# HC
satisfy apt "libicu-dev"

satisfy file-line 'Source secrets in .bashrc' ~/.bashrc 'source ~/.secrets'

# VPN
satisfy apt "openvpn"
satisfy apt "network-manager-openvpn-gnome"

function install-phantomjs () {
  wget "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2"
  bzip2 -d "phantomjs-2.1.1-linux-x86_64.tar.bz2"
  tar -xf "phantomjs-2.1.1-linux-x86_64.tar"
  sudo cp "phantomjs-2.1.1-linux-x86_64/bin/phantomjs" "/usr/local/bin/phantomjs"
}
satisfy executable "phantomjs"

if must-install apt "spotify-client"; then
  sudo apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-keys "BBEBDCB318AD50EC6865090613B00F1FD2C19886" "0DF731E45CE24F27EEEB1450EFDC8610341D9410"
  echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

  sudo apt-get -y update
fi
satisfy apt "spotify-client"

satisfy apt-ppa "ppa:peek-developers/stable"
satisfy apt "peek"

# Screenshot with CMD+SHIFT+s
satisfy dconf "/org/gnome/settings-daemon/plugins/media-keys/area-screenshot-clip" "<Shift><Super>s"

satisfy deb "webtorrent-desktop" "https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.18.0/webtorrent-desktop_0.18.0-1_amd64.deb"

# tarsnap
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
