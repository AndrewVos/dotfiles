[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/colours.icm ]] && xcalib ~/colours.icm
[[ -f ~/.backgrounds.jpg ]] && feh --no-fehbg --bg-max "$BACKGROUND"

dunst &
unclutter &
notify-on-low-battery &
compton &
highlight-active-window &

exec i3 2>&1 > ~/.i3.log
