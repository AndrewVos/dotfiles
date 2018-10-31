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

def unfocus(previous_window_id):
    print('unfocus:', previous_window_id)
    lsw = output(['lsw'])
    windows = lsw.splitlines(False)
    if len(windows) == 0:
        return print("nothing to unfocus...")

  # windows.remove(previous_window_id)
    focus_window(windows[-1])

def process_window_event(event, last_event, window_id):
    print('process_window_event:', event, last_event, window_id)
    # XCB_CREATE_NOTIFY ...... 16
    # XCB_DESTROY_NOTIFY ..... 17
    # XCB_UNMAP_NOTIFY ....... 18
    # XCB_MAP_NOTIFY ......... 19

    if event == "16":
        run(["tile.py"])
    # resize_window(window_id)
    elif event == "7":
        focus_window(window_id)
    elif event == "17":
        run(["tile.py"])
    elif event == "18":
        unfocus(window_id)
        # run(["tile.py"])
    elif event == "19":
        if last_event == "16":
            focus_window(window_id)
            run(["tile.py"])
    # resize_window(window_id)

EVENT = sys.argv[1]
LAST_EVENT = sys.argv[2]
WINDOW_ID = sys.argv[3]
process_window_event(EVENT, LAST_EVENT, WINDOW_ID)
