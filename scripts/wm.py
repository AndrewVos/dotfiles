#!/usr/bin/env python

import fileinput
import subprocess

print('starting window handler')

def run(args):
   print('run:', args)
   subprocess.run(args)

for line in fileinput.input():
   event, window_id = line.split(":")
   run(['process-window-event.py', event, window_id])
