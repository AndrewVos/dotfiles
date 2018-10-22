function fish_prompt
  if not set -q -g __vos_functions_defined
    set -g __vos_functions_defined

    function _is_git_dirty
      if [ (git rev-parse --git-dir ^/dev/null) ]
        echo (git status -s --ignore-submodules=dirty ^/dev/null)
      end
    end

    function _git_branch
      echo \((git rev-parse --abbrev-ref HEAD ^/dev/null)\)' '; or echo ''
    end
  end

  set -l dirty_colour (set_color -o red)
  set -l cwd_colour (set_color -o brblue)
  set -l clean_colour (set_color -o black)
  set -l normal_colour (set_color normal)
  set -l branch $normal_colour(_git_branch)
  set -l cwd $cwd_colour(basename (prompt_pwd))

  set dirty "$clean_colour"
  if [ (_is_git_dirty) ]
    set dirty "$dirty_colour"
  end
  set -l symbol $dirty(echo "•")

  if test $CMD_DURATION
    if test $CMD_DURATION -gt (math "1000 * 10")
      set secs (math "$CMD_DURATION / 1000")
      notify-send "$history[1]" "Returned $status, took $secs seconds"
    end
  end

  echo -n -s $cwd' '$branch''$symbol' '$normal_colour
end
