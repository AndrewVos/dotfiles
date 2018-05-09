if [[ -f ~/.Xresources ]]; then
  xrdb -merge ~/.Xresources
fi

xcalib ~/colours.icm || :
exec herbstluftwm --locked 2>&1 > ~/herbstluftwm.log
