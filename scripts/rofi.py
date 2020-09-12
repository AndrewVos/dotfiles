#!/usr/bin/python

import sys
import subprocess

def is_vpn_connected():
    result = subprocess.run(['nordvpn', 'status'], stdout=subprocess.PIPE)
    return 'Connected' in result.stdout

apps =  {
    'Chrome' : ['google-chrome-stable', 'chrome-search://local-ntp/local-ntp.html'],
    'Chrome incognito': ['google-chrome-stable --incognito chrome-search://local-ntp/local-ntp.html'],
    'Slack': ['slack'],
    'Enpass': ['enpass'],
    'Discord': ['discord'],
    'Krita': ['krita'],
    'Colour Picker': ['pick-colour-picker'],
    'Spotify': ['spotify']
}

if is_vpn_connected:
    apps['Disconnect from VPN'] = ['nordvpn', 'disconnect']
else:
    apps['Connect to VPN'] = ['nordvpn', 'connect']

if len(sys.argv) == 1:
    for title, command in apps.items():
        print(title)
else:
    for title, command in apps.items():
        if title == sys.argv[1]:
            subprocess.Popen(command, stdout=subprocess.DEVNULL)
