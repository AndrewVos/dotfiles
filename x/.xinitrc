if [[ -f ~/.Xresources ]]; then
  xrdb -merge ~/.Xresources
fi

dunst &
unclutter &
notify-on-low-battery &
compton &

setxkbmap -option ctrl:nocaps
xcalib ~/colours.icm || :
feh --no-fehbg --bg-max ~/.dotfiles/wallpapers/Zj1pTBy.png
exec i3 2>&1 > ~/.i3.log
