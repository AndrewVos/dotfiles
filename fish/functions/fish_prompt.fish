function fish_prompt
  if not set -q -g __vos_functions_defined
    set -g __vos_functions_defined

    function _is_git_dirty
      if [ (git rev-parse --git-dir ^/dev/null) ]
        echo (git status -s --ignore-submodules=dirty ^/dev/null)
      end
    end

    function _is_git_repo
      type -q git; or return 1
      git status -s >/dev/null ^/dev/null
    end
  end

  set -l date_colour (set_color -o black)
  set -l dirty_colour (set_color -o red)
  set -l cwd_colour (set_color -o brblue)
  set -l clean_colour (set_color -o white)
  set -l normal (set_color normal)

  set -l time $date_colour(date +%H:%M:%S)
  set -l cwd $cwd_colour(basename (prompt_pwd))
  set dirty "$clean_colour"
  if [ (_is_git_dirty) ]
    set dirty "$dirty_colour"
  end
  set -l symbol '•'

  echo -n -s $time' '$cwd' '$dirty$symbol' '$normal
end
