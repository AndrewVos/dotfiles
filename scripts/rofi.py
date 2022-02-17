#!/usr/bin/python

import sys
import subprocess
from pathlib import Path

def vpn_is_connected():
    result = subprocess.run(['nordvpn', 'status'], stdout=subprocess.PIPE)
    result = result.stdout.decode('utf-8')
    return result.find('Status: Connected') != -1

home = str(Path.home())
apps =  {
    'Chrome' : ['google-chrome-stable', 'chrome-search://local-ntp/local-ntp.html'],
    'Chrome incognito': ['google-chrome-stable', '--incognito', 'chrome-search://local-ntp/local-ntp.html'],
    'Slack': ['slack'],
    'Enpass': ['enpass'],
    'Sync notes': [home + '/.dotfiles/scripts/sync-notes'],

    'Discord': ['discord'],
    'Krita': ['krita'],
    'Colour Picker': ['pick-colour-picker'],
    'Spotify': ['spotify'],
    'Record screen': ['peek'],
    'Firefox': ['firefox'],
    'Boxes': ['gnome-boxes'],
    'Disk Usage': ['filelight']
}

if vpn_is_connected():
    apps['Disconnect from VPN'] = ['nordvpn', 'disconnect']
else:
    apps['Connect to VPN'] = ['nordvpn', 'connect']

if len(sys.argv) == 1:
    for title, command in apps.items():
        print(title)
else:
    command = apps[sys.argv[1]]
    subprocess.Popen(command, stdout=subprocess.DEVNULL)
