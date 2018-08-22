if [[ -f ~/.Xresources ]]; then
  xrdb -merge ~/.Xresources
fi

dunst &
unclutter &
notify-on-low-battery &
compton &
highlight-active-window &

setxkbmap -option 'ctrl:nocaps'
xcalib ~/colours.icm || :
feh --no-fehbg --bg-max ~/.dotfiles/wallpapers/pluto.jpg
exec i3 2>&1 > ~/.i3.log
