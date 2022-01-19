#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# https://gist.github.com/YoEight/d19112db56cd8f93835bf2d009d617f7

sudo tee <<'EOF' /etc/fonts/local.conf 1> /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
   <match>
      <edit mode="prepend" name="family">
         <string>Noto Sans</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>serif</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Serif</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>sans-serif</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Sans</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>monospace</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Mono</string>
      </edit>
   </match>
</fontconfig>
EOF

sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d || :
sudo ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d || :
sudo ln -s /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d || :

echo '' | sudo tee -a /etc/profile.d/freetype2.sh

FREETYPE_LINE='export FREETYPE_PROPERTIES="truetype:interpreter-version=40"'
grep -qxF "$FREETYPE_LINE" /etc/profile.d/freetype2.sh || echo "$FREETYPE_LINE" | sudo tee -a /etc/profile.d/freetype2.sh
