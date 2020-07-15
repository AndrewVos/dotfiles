# append new history items to .bash_history
shopt -s histappend
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

if [[ $- =~ i ]]; then
  fzy_history() {
    command=$(history -w /dev/stdout | fzy)
    eval $command
  }

  fzy_find_file() {
    selected="$(find * -type f | fzy)"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))

  }
  bind -m emacs-standard -x '"\C-r": fzy_history'
  bind -m emacs-standard -x '"\C-t": fzy_find_file'
fi
