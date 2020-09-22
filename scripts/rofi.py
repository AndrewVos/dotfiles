#!/usr/bin/python

import sys
import subprocess

def vpn_is_connected():
    result = subprocess.run(['nordvpn', 'status'], stdout=subprocess.PIPE)
    result = result.stdout.decode('utf-8')
    return result.find('Status: Connected') != -1

apps =  {
    'Chrome' : ['google-chrome-stable', 'chrome-search://local-ntp/local-ntp.html'],
    'Chrome incognito': ['google-chrome-stable', '--incognito', 'chrome-search://local-ntp/local-ntp.html'],
    'Slack': ['slack'],
    'Enpass': ['enpass'],
    'Notes': ['typora', '.notes'],
    'Discord': ['discord'],
    'Krita': ['krita'],
    'Colour Picker': ['pick-colour-picker'],
    'Spotify': ['spotify']
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
