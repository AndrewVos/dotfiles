HISTSIZE=100000
HISTFILESIZE=2000000

export EDITOR=vim

export PATH="$PATH:$HOME/.dotfiles/scripts"

# Alias g to git
alias g=git
# Setup g to use git completions
complete -o default -o nospace -F _git g
# Source git completions
source /usr/share/bash-completion/completions/git

source ~/.dotfiles/bash/init/ps1.sh
source ~/.dotfiles/bash/init/yarn-completion.sh
source ~/.dotfiles/bash/init/golang.sh

# make CTRL-W kill words up until \
bind '\C-w:backward-kill-word'

# Nodejs
export PATH="$PATH:node_modules/.bin"
export PATH="$PATH:$HOME/.yarn/bin"
export HUSKY_SKIP_INSTALL=yes

# Overcommit gem
export OVERCOMMIT_DISABLE=1

# Ruby
if [[ -f /usr/local/share/chruby/chruby.sh ]]; then
  source /usr/local/share/chruby/chruby.sh ||:
fi
if [[ -f /usr/local/share/chruby/auto.sh ]]; then
  source /usr/local/share/chruby/auto.sh ||:
fi

# Golang
export PATH=$PATH:~/go/bin

alias b='bundle exec'
alias ber='bundle exec rspec spec --color'
alias bec='bundle exec cucumber --color'
alias irb=pry

alias ls='exa -la'
