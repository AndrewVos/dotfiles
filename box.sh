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

sudo pacman -Syu

section "yaourt"
  function install-yaourt () {
    git clone https://aur.archlinux.org/package-query.git
    cd package-query
    makepkg -si
    cd ..
    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt
    makepkg -si
    cd ..
  }
  satisfy executable "yaourt"
end-section

yaourt --noconfirm -Syua

section "dependencies"
  satisfy pacman "git"
  satisfy pacman "curl"
  satisfy pacman "wget"
  satisfy pacman "make"
  satisfy pacman "openssh"
  satisfy pacman "bash-completion"
end-section

section "databases"
  section "postgres"
    satisfy pacman "postgresql"
    if did-install; then
      sudo su postgres -c "initdb --locale $LANG -E UTF8 -D /var/lib/postgres/data"
      sudo systemctl start postgresql.service
      sudo systemctl enable postgresql.service
      sudo su postgres -c "createuser -s $USER"
    fi
  end-section
  satisfy pacman "redis"
end-section

section "programming languages"
  section "nodejs"
    satisfy yaourt "nvm"
    satisfy yaourt "yarn"
  end-section

  section "ruby"
    satisfy yaourt "ruby-install"
    satisfy yaourt "chruby"

    section "ruby 2.4.1"
      function install-ruby-2-4-1 () {
	ruby-install ruby-2.4.1
      }
      satisfy file "ruby-2.4.1" "$HOME/.rubies/ruby-2.4.1/bin/ruby"
    end-section
  end-section

  section "golang"
    satisfy pacman "go"
  end-section
end-section

section "apps"
  satisfy pacman "htop"
  satisfy yaourt "vtop"
  satisfy pacman "shellcheck"
  satisfy pacman "playerctl"
  satisfy yaourt "hsetroot"
  satisfy pacman "xclip"
  satisfy yaourt "tmate"
  satisfy pacman "aws-cli"
  satisfy yaourt "ngrok"
  satisfy yaourt "heroku-cli"
  satisfy pacman "krita"
  satisfy yaourt "google-chrome"
  satisfy yaourt "peek"
  satisfy yaourt "slack-desktop"
  satisfy yaourt "zoom"
  satisfy yaourt "spotify"
  satisfy yaourt "spotifywm-git"
  satisfy yaourt "enpass-bin"
  satisfy pacman "unclutter"
  satisfy pacman "xorg-xinit"
  satisfy pacman "rofi"
  satisfy pacman "dunst"
  satisfy yaourt "chromedriver"
  satisfy pacman "acpi"
  satisfy yaourt "light-git"
  satisfy pacman "compton"
  satisfy yaourt "xtitle"
  satisfy yaourt "sxiv"
  satisfy pacman "feh"
  satisfy yaourt "xcalib"
  satisfy pacman "i3-wm"
  satisfy yaourt "vbar-git"
  satisfy yaourt "xrandr-invert-colors"
  satisfy yaourt "colorpicker"
  satisfy yaourt "webtorrent-desktop"
  satisfy pacman "mpv"
  satisfy yaourt "rover"
  satisfy pacman "whois"
  satisfy yaourt "jq"
  satisfy yaourt "alacritty-git"
  satisfy yaourt "ncpamixer-git"
  satisfy yaourt "undistract-me-git"
  satisfy yaourt "discord"
  satisfy yaourt "cheat"
  satisfy yaourt "ffcast"
  satisfy pacman "imagemagick"
  satisfy pacman "unzip"
  satisfy pacman "flameshot"
  satisfy pacman "dnsutils"
  satisfy pacman "transset-df"

  section "vim"
    satisfy pacman "vim"
    satisfy pacman "ctags"

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

  section "slock"
    satisfy pacman "patch"
    function install-slock () {
      git clone git://git.suckless.org/slock
      cd slock

      wget https://gist.githubusercontent.com/anonymous/0227cfef603cef9e26bd7d4660986943/raw/a1431e4e4de06b2814fc38d1fcd8d68bdba9ac6a/deep-space.patch
      patch -i deep-space.patch

      sudo make install
    }
    satisfy executable "slock"
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

  section "openvpn"
    satisfy pacman "openvpn"
    satisfy yaourt "private-internet-access-vpn"

    LOGIN_PATH="/etc/private-internet-access/login.conf"

    function install-pia-login-conf() {
      echo -n "PIA Username: "
      read -r username
      echo -n "PIA Password: "
      read -r password
      echo "$username" | sudo tee "$LOGIN_PATH"
      echo "$password" | sudo tee -a "$LOGIN_PATH"
      sudo chmod 0600 /etc/private-internet-access/login.conf
      sudo chown root:root /etc/private-internet-access/login.conf
      sudo pia -a
    }
    satisfy file "pia-login-conf" "$LOGIN_PATH"
  end-section
end-section

section "dotfiles"
  satisfy github "https://github.com/AndrewVos/dotfiles" "$HOME/.dotfiles"
  satisfy pacman "stow"
  stow --verbose --target ~ alacritty bash compton ctags dunst fontconfig git gtk2 gtk3 i3 rofi ssh vbar x

  product=$(cat /sys/devices/virtual/dmi/id/product_family)
  if [[ "$product" = "ThinkPad T480" ]]; then
    stow --verbose --target ~ t480

    # Trackpoint config
    sudo stow --verbose --target / hwdb

    # Powertop config
    sudo stow --verbose --target / powertop
    systemctl status powertop.service > /dev/null || sudo systemctl enable powertop.service
  fi

  sudo stow --verbose --target / X11

  section "themes"
    satisfy pacman "arc-gtk-theme"
  end-section

  satisfy file-line "Source bash init.sh" ~/.bashrc "source ~/.dotfiles/bash/init.sh"

  satisfy file-line "Start X automatically" ~/.bash_profile 'if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec startx &> /dev/null; fi'
end-section

section "fonts"
  satisfy pacman "ttf-hack"
  satisfy pacman "ttf-font-awesome"
  satisfy yaourt "mplus-font"
  satisfy yaourt "otf-unscii-16-full"
  satisfy pacman "noto-fonts"
  satisfy pacman "adobe-source-code-pro-fonts"
  satisfy pacman "ttf-ubuntu-font-family"
  satisfy yaourt "ttf-material-icons"

  # from https://aur.archlinux.org/packages/ttf-google-fonts-git/
  satisfy yaourt "noto-fonts-extra"
  satisfy yaourt "ttf-croscore"
  satisfy yaourt "ttf-fira-mono"
  satisfy yaourt "ttf-fira-sans"
  satisfy yaourt "ttf-inconsolata"
  satisfy yaourt "ttf-merriweather"
  satisfy yaourt "ttf-merriweather-sans"
  satisfy yaourt "ttf-opensans"
  satisfy yaourt "ttf-oswald"
  satisfy yaourt "ttf-quintessential"
  satisfy yaourt "ttf-roboto"
  satisfy yaourt "ttf-signika"
  satisfy yaourt "ttf-ubuntu-font-family"

  function install-no-bitmaps() {
    sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
  }
  satisfy file "no-bitmaps" "/etc/fonts/conf.d/70-no-bitmaps.conf"

  function install-sub-pixel-rgb() {
    sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
  }
  satisfy file "sub-pixel-rgb" "/etc/fonts/conf.d/10-sub-pixel-rgb.conf"

  function install-lcdfilter-default() {
    sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
  }
  satisfy file "lcdfilter-default" "/etc/fonts/conf.d/11-lcdfilter-default.conf"
end-section
