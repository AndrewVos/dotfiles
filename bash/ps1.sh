git_prompt_color () {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if ! git status | grep "nothing to commit" > /dev/null 2>&1; then
      echo -e "\033[0;31m"
      return 0
    fi
  fi
  echo -e "\033[0;37m"
}

DATE_COLOUR="\033[1;30m"
DIR_COLOUR="\033[1;34m"
RESET_COLOUR="\033[0m"

export PS1="\[$DATE_COLOUR\]\$(date +%H:%M:%S)\[$RESET_COLOUR\] \[$DIR_COLOUR\]\W\[$RESET_COLOUR\]\$(__git_ps1) \[\$(git_prompt_color)\]•\[$RESET_COLOUR\] "
