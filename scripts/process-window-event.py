#!/usr/bin/env python

import subprocess
import sys

def focus_window(window_id):
   print("focusing:", window_id)
   # put it on top of the stack
   subprocess.run(['chwso', '-r', window_id])
   # set focus to it
   subprocess.run(['wtf', window_id])

def output(args):
   return subprocess.check_output(args).decode('utf-8').strip()

def run(args):
   print('run:', args)
   subprocess.run(args)

def resize_window(window_id):
   root = output(['lsw', '-r'])
   screen_width = output(['wattr', 'w', root])
   screen_height = output(['wattr', 'h', root])
   subprocess.run(['wmv', '100', '100', window_id])
   subprocess.run(['wtp', '0', '0', screen_width, screen_height, window_id])

def focus_previous():
   lsw = subprocess.check_output(['lsw']).decode('utf-8').strip()
   windows = lsw.splitlines(False)
   focus_window(windows(-1))

event = sys.argv[1]
window_id = sys.argv[2]

# XCB_CREATE_NOTIFY ...... 16
# XCB_DESTROY_NOTIFY ..... 17
# XCB_UNMAP_NOTIFY ....... 18
# XCB_MAP_NOTIFY ......... 19

if event == "16":
   resize_window(window_id)
elif event == "18":
   focus_previous
elif event == "19":
   focus_window(window_id)
   resize_window(window_id)
