set fish_greeting

set -Ux EDITOR kak
set -Ux BROWSER google-chrome-stable
set -Ux _JAVA_AWT_WM_NONREPARENTING 1

fish_add_path $HOME/.dotfiles/scripts
fish_add_path /usr/local/go/bin
fish_add_path "(yarn global bin)"

# set --export PATH $PATH ./node_modules/.bin

# ayu light
set fish_color_normal "575F66"
set fish_color_autosuggestion "8A9199"
set fish_color_command "55B4D4"
set fish_color_comment "ABB0B6"
set fish_color_cancel "\x2dr"
set fish_color_cwd "399EE6"
set fish_color_cwd_root "red"
set fish_color_end "ED9366"
set fish_color_error "F51818"
set fish_color_escape "4CBF99"
set fish_color_history_current "\x2d\x2dbold"
set fish_color_host "normal"
set fish_color_host_remote "yellow"
set fish_color_match "F07171"
set fish_color_operator "FF9940"
set fish_color_param "575F66"
set fish_color_quote "86B300"
set fish_color_redirection "A37ACC"
set fish_color_search_match "\x2d\x2dbackground\x3dFF9940"
set fish_color_selection "\x2d\x2dbackground\x3dFF9940"
set fish_color_status "red"
set fish_color_user "brgreen"
set fish_color_valid_path "\x2d\x2dunderline"
set fish_pager_color_completion "normal"
set fish_pager_color_description "B3A06D\x1eyellow"
set fish_pager_color_prefix "normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline"
set fish_pager_color_progress "brwhite\x1e\x2d\x2dbackground\x3dcyan"

# git prompt
set __fish_git_prompt_color_branch yellow

set __fish_git_prompt_color_dirtystate red
set __fish_git_prompt_char_dirtystate '•'
set __fish_git_prompt_showdirtystate 'yes'

set __fish_git_prompt_showstagedstate 'yes'
set __fish_git_prompt_char_stagedstate '•'
set __fish_git_prompt_color_stagedstate red

set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_char_untrackedfiles '•'
set __fish_git_prompt_color_untrackedfiles red

# asdf
source /opt/asdf-vm/asdf.fish

# ssh-agent
if test -z (pgrep ssh-agent)
  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end
