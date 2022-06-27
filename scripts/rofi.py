#!/usr/bin/python

import sys
import subprocess
from pathlib import Path

home = str(Path.home())
apps =  {
    'Chrome' : ['google-chrome-stable', 'chrome-search://local-ntp/local-ntp.html'],
    'Chrome incognito': ['google-chrome-stable', '--incognito', 'chrome-search://local-ntp/local-ntp.html'],
    'Slack': ['slack'],
    'Teams': ['teams'],
    'Enpass': ['enpass'],
    'Sync': [home + '/.dotfiles/scripts/sync'],
    'Pulls': ['xdg-open', 'https://github.com/pulls'],

    'Discord': ['discord'],
    'Krita': ['krita'],
    'Colour Picker': ['pick-a-colour'],
    'Spotify': ['spotify'],
    'Record screen': ['peek'],
    'Boxes': ['gnome-boxes'],
    'Equalizer': ['pulseaudio-equalizer-gtk']
}

if len(sys.argv) == 1:
    for title, command in apps.items():
        print(title)
else:
    command = apps[sys.argv[1]]
    subprocess.Popen(command, stdout=subprocess.DEVNULL)
