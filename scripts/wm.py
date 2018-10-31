#!/usr/bin/env python

import fileinput
import subprocess

print('starting window handler')

def run(args):
   print('run:', args)
   subprocess.run(args, check=True)

last_event = ''

for line in fileinput.input():
   event, window_id = line.strip().split(":")
   run(['process-window-event.py', event, last_event, window_id])
   last_event = event
