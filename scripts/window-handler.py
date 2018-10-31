#!/usr/bin/env python

import fileinput
import subprocess

def focus_window(window_id):
    # put it on top of the stack
    subprocess.check_output(['chwso', '-r', window_id])
   # set focus to it
    subprocess.check_output(['wtf', window_id])

def focus_delta(backwards=True):
    current_window = subprocess.check_output(['pfw']).strip()
    print("current window:" , current_window)
#  CURRENT_WINDOW=$(pfw)

    windows = "\n".split(subprocess.check_output(['lsw']).strip())

    if backwards:
        index = windows.index(current_window) - 1
        if index == -1:
            index = windows.length - 1
    else:
        index = windows.index(current_window) + 1
        if index == windows.length:
            index = 0

    window = windows[index]
    focus_window(window)

    # index = windows.index(current_window)


#  if [[ "$WID" = "prev" ]]; then
#    WID=$(lsw | grep -v "$CURRENT_WINDOW" | sed '$ p;d')
#  elif  [[ "$WID" = "next" ]]; then
#    WID=$(lsw | grep -v "$CURRENT_WINDOW" | sed '1 p;d')
#  fi

#  if [[ "$WID" != "" ]]; then
#    # put it on top of the stack
#    chwso -r "$WID"
#    # set focus to it
#    wtf "$WID"

#    # resize "$WID"
#  fi

for line in fileinput.input():
    event, window_id = line.split(":")
    print(event)
    print(window_id)
    print("")

    if event == "18":
        focus_delta(True)
    elif event == "19":
        focus_window(window_id)

#  if [[ "$ev" = "16" ]]; then
#    wattr o "$wid" || :
#  elif [[ "$ev" = "18" ]]; then
#    focus prev
#  elif [[ "$ev" = "19" ]]; then
#    focus "$wid"
#  fi

##!/usr/bin/env bash
#set -euo pipefail
#IFS=$'\n\t'

#set -x

#function focus() {
#  WID=$1

#  pfw || wtf "$(lsw)" # only needed for testing when WM already launched

#  CURRENT_WINDOW=$(pfw)

#  if [[ "$WID" = "prev" ]]; then
#    WID=$(lsw | grep -v "$CURRENT_WINDOW" | sed '$ p;d')
#  elif  [[ "$WID" = "next" ]]; then
#    WID=$(lsw | grep -v "$CURRENT_WINDOW" | sed '1 p;d')
#  fi

#  if [[ "$WID" != "" ]]; then
#    # put it on top of the stack
#    chwso -r "$WID"
#    # set focus to it
#    wtf "$WID"

#    # resize "$WID"
#  fi
#}

#function resize() {
#  ROOT=$(lsw -r)
#  SCREEN_WIDTH=$(wattr w "$ROOT")
#  SCREEN_HEIGHT=$(wattr h "$ROOT")

#  wtp 0 0 "$SCREEN_WIDTH" "$SCREEN_HEIGHT" "$WID"
#}

#while IFS=: read -r ev wid; do
#  # XCB_CREATE_NOTIFY ...... 16
#  # XCB_DESTROY_NOTIFY ..... 17
#  # XCB_UNMAP_NOTIFY ....... 18
#  # XCB_MAP_NOTIFY ......... 19

#  if [[ "$ev" = "16" ]]; then
#    wattr o "$wid" || :
#  elif [[ "$ev" = "18" ]]; then
#    focus prev
#  elif [[ "$ev" = "19" ]]; then
#    focus "$wid"
#  fi
#done

