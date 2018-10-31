#!/usr/bin/env python

import subprocess

def output(args):
    return subprocess.check_output(args).decode("utf-8").strip()


def run(args):
    print("run:", args)
    subprocess.run(args, check=True)


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


tile()
