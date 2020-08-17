_yarn_complete() {
  local cur_word prev_word scripts

  cur_word="${COMP_WORDS[COMP_CWORD]}"
  prev_word="${COMP_WORDS[COMP_CWORD-1]}"

  scripts=$(jq '.scripts | keys[]' package.json | paste)

  COMPREPLY=( $(compgen -W "${scripts}" -- ${cur_word}) )
  return 0
}

complete -F _yarn_complete yarn
