if [[ -f ~/.Xresources ]]; then
  xrdb -merge ~/.Xresources
fi
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

dunst &
unclutter &
notify-on-low-battery &
compton &
highlight-active-window &

xcalib ~/colours.icm || :
feh --no-fehbg --bg-max ~/.dotfiles/wallpapers/pluto.jpg
exec i3 2>&1 > ~/.i3.log
