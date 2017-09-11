# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Kill the word up until the last \
stty werase undef
bind '"\C-w": backward-kill-word'

# chruby {
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
# }

# go {
  export GOPATH="$HOME/gopath"
  export PATH="$GOPATH/bin:$PATH"
  export PATH="$PATH:/usr/local/go/bin"
# }

# node {
export PATH="$PATH:node_modules/.bin"
# }

# rust {
  export PATH="$HOME/.cargo/bin:$PATH"
# }

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Nim
export PATH="/home/andrew/Nim/bin:$PATH"

export EDITOR=vim
export PATH=$PATH:~/dotfiles/scripts
export PATH=$PATH:~/dotfiles/git-scripts

# aliases {
  alias g="git"
  source /usr/share/bash-completion/completions/git
  complete -o default -o nospace -F _git g

  alias b="bundle exec"
  alias ber="bundle exec rspec spec --color"
  alias bec="bundle exec cucumber --color"
  alias irb="pry"
  alias ls="ls -1 -G --color=auto"
  alias ll='ls -ahlF --color=auto'
# }

# directory-jumper {
  #http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
  export MARKPATH=$HOME/.marks
  function j {
      cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
  }
  function j-mark {
      mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
  }
  function j-unmark {
      rm -i $MARKPATH/$1
  }
  function marks {
      ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
  }

  if [ "$SHELL" = "/bin/zsh" ]; then
    function _marks {
      reply=($(ls $MARKPATH))
    }
    compctl -K _marks j
    compctl -K _marks j-unmark
  fi

  if [ "$SHELL" = "/bin/bash" ]; then
    function _completemarks() {
      local curw=${COMP_WORDS[COMP_CWORD]}
      local wordlist=$(find $MARKPATH -type l -printf "%f\n")
      COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
      return 0
    }
    complete -F _completemarks j j-unmark
  fi
# }

# ssh-agent {{
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
  fi
# }}

# gpg-agent {{
  GPG_TTY=$(tty)
  export GPG_TTY
# }}

# battery, username, working directory, git, exit code
export PWOMPT_CONFIG='battery_charging?("white", "⏚")not_battery_charging?("white", "⌁")battery_percentage("red", "yellow", "green")battery?("white", " ")c("yellow", "[")user("magenta")c("white",":")cwd_short("blue")c("yellow", "]")git?("white", " ")git_branch("magenta")git_dirty?("red", "*")last_exit_failed?("white", " ")last_exit_code("red")git?("white", " ±")not_git?("white", " ∴")c("white", " ")'
export PWOMPT_CONFIG='c("yellow", "[")cwd_short("blue")c("yellow", "]")git?("white", " ")git_branch("magenta")git_dirty?("red", "*")last_exit_failed?("white", " ")last_exit_code("red")c("white", " ∞")c("white", " ")'

PS1='$(PWOMPT_LAST_EXIT_CODE=$? pwompt)'

alias weechat='TERM=xterm-256color weechat'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/vos/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '/home/vos/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/vos/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '/home/vos/Downloads/google-cloud-sdk/completion.bash.inc'; fi

export PATH=$PATH:~/.yarn/bin # Add yarn binaries to PATH in .bashrc
source ~/.secrets # Source secrets in .bashrc
