#!/usr/bin/env python

import subprocess
import sys

def focus_window(window_id):
   print("focusing:", window_id)
   # put it on top of the stack
   run(['chwso', '-r', window_id])
   # set focus to it
   run(['wtf', window_id])

def output(args):
   return subprocess.check_output(args).decode('utf-8').strip()

def run(args):
   print('run:', args)
   subprocess.run(args, check=True)

def resize_window(window_id):
   root = output(['lsw', '-r'])
   screen_width = output(['wattr', 'w', root])
   screen_height = output(['wattr', 'h', root])
   run(['wtp', '0', '0', screen_width, screen_height, window_id])

action = sys.argv[1]
print('focus:', action)

if action == "previous":
   current_window = output(['pfw'])
   lsw = output(['lsw'])
   windows = lsw.splitlines(False)
   windows.remove(current_window)
   focus_window(windows[-1])
elif action == "next":
   current_window = output(['pfw'])
   lsw = output(['lsw'])
   windows = lsw.splitlines(False)
   windows.remove(current_window)
   focus_window(windows[0])
