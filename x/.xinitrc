export PATH=$PATH:/home/andrewvos/.dotfiles/scripts

xrdb -merge ~/.Xresources

rm -rf /tmp/workspaces
workspace.sh -i

xcalib ~/colours.icm
feh --no-fehbg --bg-max ~/.background.jpg
# vbar start &
dunst &
unclutter &
notify-on-low-battery &
compton --no-fading-openclose &
highlight-active-window &

wew | wm.py &
exec sxhkd
# exec i3 2>&1 > ~/.i3.log
