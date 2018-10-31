export PATH=$PATH:/home/andrewvos/.dotfiles/scripts

# screenstuff.sh
# focus_watcher.sh &

rm -rf /tmp/workspaces
workspace.sh -i

sxhkd &
exec wew | wm.py
# exec i3 2>&1 > ~/.i3.log
