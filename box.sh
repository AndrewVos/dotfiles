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

function install-vim () {
  sudo apt install xorg-dev ncurses-dev

  git clone https://github.com/vim/vim.git --depth 1
  cd vim
  ./configure --enable-pythoninterp
  make
  sudo make install
}
satisfy executable "vim"

satisfy apt "exuberant-ctags"

satisfy apt "git"
satisfy apt "nim"

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
satisfy go-package "github.com/AndrewVos/pwompt"

satisfy github "https://github.com/AndrewVos/vimfiles" "$HOME/vimfiles"
satisfy symlink "$HOME/vimfiles/.vimrc" "$HOME/.vimrc"
satisfy symlink "$HOME/vimfiles/.vim" "$HOME/.vim"
(cd $HOME/vimfiles && ./plugins.sh)

DOTFILES_PATH="$HOME/dotfiles"
satisfy github "https://github.com/AndrewVos/dotfiles" "$DOTFILES_PATH"
satisfy symlink "$DOTFILES_PATH/bash/.bash_profile.symlink"   "$HOME/.bash_profile"
satisfy symlink "$DOTFILES_PATH/bash/.bashrc.symlink"         "$HOME/.bashrc"
satisfy symlink "$DOTFILES_PATH/bash/.inputrc.symlink"        "$HOME/.inputrc"
satisfy symlink "$DOTFILES_PATH/git/.git-template.symlink"    "$HOME/.git-template"
satisfy symlink "$DOTFILES_PATH/git/.gitconfig.symlink"       "$HOME/.gitconfig"
satisfy symlink "$DOTFILES_PATH/git/.gitignore.symlink"       "$HOME/.gitignore"
satisfy symlink "$DOTFILES_PATH/screen/.screenrc.symlink"     "$HOME/.screenrc"
satisfy symlink "$DOTFILES_PATH/ssh/.ssh/config.symlink"      "$HOME/.ssh/config"
satisfy symlink "$DOTFILES_PATH/tarsnap/.tarsnap.key.symlink" "$HOME/.tarsnap.key"
satisfy symlink "$DOTFILES_PATH/tarsnap/.tarsnaprc.symlink"   "$HOME/.tarsnaprc"

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
satisfy file-line 'Add yarn binaries to PATH in .bashrc' ~/.bashrc 'export PATH=$PATH:~/.yarn/bin'

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
