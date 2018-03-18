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
      makepkg --no-confirm -si
      cd ..
      git clone https://aur.archlinux.org/yaourt.git
      cd yaourt
      makepkg --no-confirm -si
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
    satisfy file-line "Add go binaries to PATH" ~/.bashrc 'export PATH="$PATH:/usr/local/go/bin"'
    satisfy file-line "Export GOPATH" ~/.bashrc 'export GOPATH="$HOME/gopath"'
    satisfy file-line "Add go package binaries to PATH" ~/.bashrc 'export PATH="$GOPATH/bin:$PATH"'
    export PATH="$PATH:/usr/local/go/bin"
    satisfy golang "go1.9"
  end-section
end-section

section "fonts"
  satisfy pacman "ttf-hack"
  satisfy pacman "ttf-font-awesome"
end-section

section "apps"
  satisfy pacman "htop"
  satisfy pacman "shellcheck"
  satisfy pacman "scrot"
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
  satisfy pacman "redshift"
  satisfy pacman "unclutter"
  satisfy pacman "xorg-xinit"
  satisfy pacman "i3-wm"
  satisfy pacman "compton"
  satisfy pacman "rofi"
  satisfy pacman "dunst"
  satisfy yaourt "dunstify"
  satisfy yaourt "chromedriver"
  satisfy pacman "acpi"

  if must-install yaourt "discord"; then
    gpg --recv-keys 8F0871F202119294
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

      wget https://gist.githubusercontent.com/AndrewVos/e3fcdcf4b1fb839cdf2ea175db0bdbbf/raw/5eb8b23111de0ef941cf5c44dd0c7ef63c850714/deep-space.patch
      patch -i deep-space.patch

      wget https://st.suckless.org/patches/scrollback/st-scrollback-20180311-c5ba9c0.diff
      patch -i st-scrollback-20180311-c5ba9c0.diff
      wget https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20180311-c5ba9c0.diff
      patch -i st-scrollback-mouse-20180311-c5ba9c0.diff

      sudo make clean install
      cd ..
    }
    satisfy executable "st"
    satisfy file-line "Set the window title in st" ~/.bashrc 'PROMPT_COMMAND='"'"'_terminal_title'"'"''
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
end-section

section "dotfiles"
  DOTFILES_PATH="$HOME/.dotfiles"
  satisfy github "https://github.com/AndrewVos/dotfiles" "$DOTFILES_PATH"

  satisfy symlink "$DOTFILES_PATH/libinput/etc/X11/xorg.conf.d/30-touchpad.conf" "/etc/X11/xorg.conf.d/30-touchpad.conf"
  satisfy symlink "$DOTFILES_PATH/bash/.inputrc" "$HOME/.inputrc"
  satisfy symlink "$DOTFILES_PATH/git/.git-template" "$HOME/.git-template"
  satisfy symlink "$DOTFILES_PATH/git/.gitconfig" "$HOME/.gitconfig"
  satisfy symlink "$DOTFILES_PATH/git/.gitignore" "$HOME/.gitignore"
  satisfy symlink "$DOTFILES_PATH/screen/.screenrc" "$HOME/.screenrc"

  mkdir -p "$HOME/.config/i3"
  satisfy symlink "$DOTFILES_PATH/i3/.config/i3/config" "$HOME/.config/i3/config"

  mkdir -p "$HOME/.config/dunst"
  satisfy symlink "$DOTFILES_PATH/dunst/.config/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"

  mkdir -p "$HOME/.ssh"
  satisfy symlink "$DOTFILES_PATH/ssh/.ssh/config" "$HOME/.ssh/config"

  satisfy symlink "$DOTFILES_PATH/tarsnap/.tarsnaprc" "$HOME/.tarsnaprc"
  satisfy symlink "$DOTFILES_PATH/fish" "$HOME/.config/fish"
  satisfy symlink "$DOTFILES_PATH/ctags/.ctags" "$HOME/.ctags"

  satisfy file-line "Add dotfiles scripts to PATH" ~/.bashrc "export PATH=\$PATH:$DOTFILES_PATH/scripts"
  satisfy file-line "Setup ssh-agent" ~/.bashrc "source $DOTFILES_PATH/bash/ssh-agent.sh"
  satisfy file-line "Setup gpg-agent" ~/.bashrc "source $DOTFILES_PATH/bash/gpg-agent.sh"
  satisfy file-line "Use custom PS1" ~/.bashrc "source $DOTFILES_PATH/bash/ps1.sh"

  satisfy file-line "Start X automatically" ~/.bash_profile 'if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec startx; fi'
  satisfy file-line "Start i3 automatically" ~/.xinitrc 'exec i3'
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
