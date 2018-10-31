#!/usr/bin/env python

import fileinput
import subprocess

print('starting window handler')

def run(args):
    print('run:', args)
    subprocess.run(args, check=True)

last_event = ''

for line in fileinput.input():
    event = line.strip()
    try:
        run(['process-window-event.py', event, last_event])
    except subprocess.CalledProcessError as err:
        print(err.output)

    last_event = event
