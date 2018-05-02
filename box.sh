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
  satisfy pacman "git"
  satisfy pacman "curl"
  satisfy pacman "wget"
  satisfy pacman "make"
  satisfy pacman "openssh"
  satisfy pacman "bash-completion"
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
    satisfy file-line "Source nvm" ~/.bashrc "source /usr/share/nvm/init-nvm.sh"
    satisfy file-line "Add node_modules bin to PATH" ~/.bashrc 'export PATH="$PATH:node_modules/.bin"'
    satisfy file-line 'Add yarn binaries to PATH' ~/.bashrc 'export PATH=$PATH:~/.yarn/bin'
    satisfy file-line "Ensure husky doesn't install git hooks" ~/.bashrc 'export HUSKY_SKIP_INSTALL=yes'
  end-section

  section "ruby"
    satisfy yaourt "ruby-install"
    satisfy yaourt "chruby"
    satisfy file-line "Source chruby" ~/.bashrc "source /usr/share/chruby/chruby.sh"
    satisfy file-line "Source chruby-auto" ~/.bashrc "source /usr/share/chruby/auto.sh"

    section "ruby 2.4.1"
      function install-ruby-2-4-1 () {
	ruby-install ruby-2.4.1
      }
      satisfy file "ruby-2.4.1" "$HOME/.rubies/ruby-2.4.1/bin/ruby"
    end-section
  end-section

  section "golang"
    satisfy pacman "go"
    satisfy file-line "Add golang binaries to PATH" ~/.bashrc "export PATH=\$PATH:~/go/bin"
  end-section
end-section

section "fonts"
  satisfy pacman "ttf-hack"
  satisfy pacman "ttf-font-awesome"
  satisfy yaourt "mplus-font"
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
  satisfy pacman "gimp"
  satisfy yaourt "google-chrome"
  satisfy yaourt "peek"
  satisfy yaourt "slack-desktop"
  satisfy yaourt "zoom"
  satisfy yaourt "spotify"
  satisfy yaourt "enpass-bin"
  satisfy pacman "unclutter"
  satisfy pacman "xorg-xinit"
  satisfy pacman "rofi"
  satisfy pacman "dunst"
  satisfy yaourt "chromedriver"
  satisfy pacman "acpi"
  satisfy pacman "maim"
  satisfy yaourt "light-git"
  satisfy pacman "compton"
  satisfy yaourt "xtitle"
  satisfy yaourt "sxiv"
  satisfy pacman "transset-df"
  satisfy pacman "feh"
  satisfy yaourt "xcalib"
  satisfy yaourt "herbstluftwm"
  satisfy yaourt "xrandr-invert-colors"
  satisfy yaourt "colorpicker"
  satisfy yaourt "webtorrent-desktop"
  satisfy pacman "mpv"

  satisfy yaourt "undistract-me-git"
  satisfy file-line "Source undistract-me" ~/.bashrc 'source /etc/profile.d/undistract-me.sh'

  if must-install yaourt "discord"; then
    gpg --recv-keys 11E521D646982372EB577A1F8F0871F202119294
    gpg --recv-keys B6C8F98282B944E3B0D5C2530FC3042E345AD05D
  fi
  satisfy yaourt "discord"

  section "vim"
    satisfy pacman "vim"
    satisfy file-line "Make vim the default EDITOR" ~/.bashrc 'export EDITOR=vim'
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

  section "st"
    satisfy pacman "patch"

    function install-st() {
      git clone git://git.suckless.org/st
      cd st

      wget https://gist.githubusercontent.com/AndrewVos/eed92c3b3439cf289878e71a46aec38b/raw/d746a14149359658655e2d518516cf63378db58d/forgotten.patch
      patch -i forgotten.patch

      wget https://st.suckless.org/patches/scrollback/st-scrollback-0.8.diff
      patch -i st-scrollback-0.8.diff

      wget https://st.suckless.org/patches/scrollback/st-scrollback-mouse-0.8.diff
      patch -i st-scrollback-mouse-0.8.diff

      sudo make install
    }
    satisfy executable "st"
    satisfy file-line "Set the window title in st" ~/.bashrc 'PROMPT_COMMAND='"'"'_terminal_title'"'"''
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
    satisfy yaourt "openvpn-pia"
    function install-pia-credentials() {
      echo -n "PIA Username:"
      read username
      echo -n "PIA Password:"
      read password
      echo "$username" | sudo tee "/etc/openvpn-pia.conf"
      echo "$password" | sudo tee -a "/etc/openvpn-pia.conf"
    }
    satisfy file "pia-credentials" "/etc/openvpn-pia.conf"
  end-section
end-section

section "dotfiles"
  DOTFILES_PATH="$HOME/.dotfiles"
  satisfy github "https://github.com/AndrewVos/dotfiles" "$DOTFILES_PATH"

  satisfy symlink "$DOTFILES_PATH/libinput/etc/X11/xorg.conf.d/30-touchpad.conf" "/etc/X11/xorg.conf.d/30-touchpad.conf"
  satisfy symlink "$DOTFILES_PATH/bash/.inputrc" "$HOME/.inputrc"
  satisfy symlink "$DOTFILES_PATH/git/.git-template" "$HOME/.git-template"
  satisfy symlink "$DOTFILES_PATH/git/.gitconfig" "$HOME/.gitconfig"
  satisfy symlink "$DOTFILES_PATH/git/.gitignore" "$HOME/.gitignore"

  satisfy symlink "$DOTFILES_PATH/x/.xinitrc" "$HOME/.xinitrc"

  mkdir -p "$HOME/.config/herbstluftwm"
  satisfy symlink "$DOTFILES_PATH/herbstluftwm/.config/herbstluftwm/autostart" "$HOME/.config/herbstluftwm/autostart"

  mkdir -p "$HOME/.config/vbar"
  satisfy symlink "$DOTFILES_PATH/vbar/.config/vbar/vbarrc" "$HOME/.config/vbar/vbarrc"

  mkdir -p "$HOME/.config/dunst"
  satisfy symlink "$DOTFILES_PATH/dunst/.config/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"

  mkdir -p "$HOME/.config/rofi"
  satisfy symlink "$DOTFILES_PATH/rofi/.config/rofi/config" "$HOME/.config/rofi/config"
  satisfy symlink "$DOTFILES_PATH/rofi/.config/rofi/nord.rasi" "$HOME/.config/rofi/nord.rasi"

  mkdir -p "$HOME/.ssh"
  satisfy symlink "$DOTFILES_PATH/ssh/.ssh/config" "$HOME/.ssh/config"

  satisfy symlink "$DOTFILES_PATH/ctags/.ctags" "$HOME/.ctags"

  section "themes"
    satisfy pacman "arc-gtk-theme"
    satisfy symlink "$DOTFILES_PATH/gtk2/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
    mkdir -p "$HOME/.config/gtk-3.0"
    satisfy symlink "$DOTFILES_PATH/gtk3/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
  end-section

  satisfy file-line "Add dotfiles scripts to PATH" ~/.bashrc "export PATH=\$PATH:$DOTFILES_PATH/scripts"
  satisfy file-line "Setup ssh-agent" ~/.bashrc "source $DOTFILES_PATH/bash/ssh-agent.sh"
  satisfy file-line "Setup gpg-agent" ~/.bashrc "source $DOTFILES_PATH/bash/gpg-agent.sh"
  satisfy file-line "Use custom PS1" ~/.bashrc "source $DOTFILES_PATH/bash/ps1.sh"

  satisfy file-line "Start X automatically" ~/.bash_profile 'if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec startx; fi'
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
