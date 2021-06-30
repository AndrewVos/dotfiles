set fish_greeting

set -Ux EDITOR kak
set -Ux BROWSER google-chrome-stable
set -Ux GOPATH "$HOME/gopath"

fish_add_path $HOME/.dotfiles/scripts
fish_add_path /usr/local/go/bin
fish_add_path "$GOPATH/bin"
fish_add_path "node_modules/.bin"
fish_add_path "(yarn global bin)"

source /opt/asdf-vm/asdf.fish
