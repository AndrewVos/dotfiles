#!/usr/bin/env python

import subprocess
import sys

def output(args):
   return subprocess.check_output(args).decode('utf-8').strip()

def run(args):
   print('run:', args)
   subprocess.run(args, check=True)

def cycle():
   current_window = output(['pfw'])
   windows = output(['lsw']).splitlines(False)
   windows.remove(current_window)
   next_window = windows[-1]

   run(['chwso', '-r', next_window])
   run(['wtf', next_window])
   run(['chwso', '-l', current_window])

cycle()
