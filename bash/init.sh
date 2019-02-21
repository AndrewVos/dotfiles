HISTSIZE=100000
HISTFILESIZE=2000000

export EDITOR=vim

export PATH=$PATH:~/.dotfiles/scripts

# Alias g to git
alias g=git
# Setup g to use git completions
complete -o default -o nospace -F _git g
# Source git completions
source /usr/share/bash-completion/completions/git

alias b='bundle exec'
alias ber='bundle exec rspec spec --color'
alias bec='bundle exec cucumber --color'
alias irb=pry

alias ls='exa -la'

source ~/.dotfiles/bash/init/ps1.sh
source ~/.dotfiles/bash/init/yarn-completion.sh

# Nodejs
export PATH="$PATH:node_modules/.bin"
export PATH="$PATH:$HOME/.yarn/bin"
export HUSKY_SKIP_INSTALL=yes

# Ruby
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Golang
export PATH=$PATH:~/go/bin
