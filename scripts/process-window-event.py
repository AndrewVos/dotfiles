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

def ignore_window(window_id):
    try:
        run(['wattr', 'o', window_id])
        return True
    except subprocess.CalledProcessError:
        return False

def build_layout(window_count):
    if window_count == 1:
        return [(0, 0, 1, 1)]

    if window_count == 2:
        return [(0, 0, 0.5, 1), (0.5, 0, 0.5, 1)]

    if window_count == 3:
        return [(0, 0, 0.5, 1), (0.5, 0, 0.5, 0.5), (0.5, 0.5, 0.5, 0.5)]

    if window_count == 4:
        return [(0, 0, 0.5, 0.5), (0.5, 0, 0.5, 0.5), (0, 0.5, 0.5, 0.5), (0.5, 0.5, 0.5, 0.5)]

def tile():
    windows = output(["lsw"]).splitlines(False)

    layout = build_layout(len(windows))

    root = output(["lsw", "-r"])
    screen_width = int(output(["wattr", "w", root]))
    screen_height = int(output(["wattr", "h", root]))

    print(windows)

    for index, window in enumerate(windows):
        x, y, width, height = layout[index]

        x = x * screen_width
        y = y * screen_height
        width = width * screen_width
        height = height * screen_height

        print(x, y, width, height)
        run(["wtp", str(x), str(y), str(width), str(height), window])

def process_window_event(event, last_event):
    print('process_window_event:', event, last_event)

    if ignore_window(event.window_id):
      return

    # XCB_CREATE_NOTIFY ...... 16
    # XCB_DESTROY_NOTIFY ..... 17
    # XCB_UNMAP_NOTIFY ....... 18
    # XCB_MAP_NOTIFY ......... 19

    if event.event_id == 16:
        tile()
    # resize_window(window_id)
    elif event.event_id == 7:
        focus_window(event.window_id)
    elif event.event_id == 17:
        tile()
    elif event.event_id == 18:
        unfocus(event.window_id)
        # run(["tile.py"])
    elif event.event_id == 19:
        if last_event and last_event.event_id == 16 and last_event.window_id == event.window_id:
            focus_window(event.window_id)
            tile()
    # resize_window(window_id)

class WindowEvent:
    def __init__(self, event_id, window_id):
        self.event_id = event_id
        self.window_id = window_id

    @classmethod
    def from_string(cls, string):
        if string == '':
            return None

        event_id, window_id = string.split(":")
        return cls(int(event_id), window_id)

process_window_event(
    WindowEvent.from_string(sys.argv[1]),
    WindowEvent.from_string(sys.argv[2])
)
