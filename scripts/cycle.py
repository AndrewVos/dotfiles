#!/usr/bin/env python

import subprocess

def output(args):
    return subprocess.check_output(args).decode('utf-8').strip()

def run(args):
    print('run:', args)
    subprocess.run(args, check=True)

def cycle():
    current_window = output(['pfw'])
    windows = output(['lsw']).splitlines(False)

    index = windows.index(current_window)
    index += 1
    if index == len(windows):
       index = 0

    next_window = windows[index]

    run(['wtf', next_window])

cycle()
