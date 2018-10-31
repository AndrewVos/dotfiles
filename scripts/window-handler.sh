#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

set -x

function focus() {
  WID=$1

  pfw || wtf "$(lsw)" # only needed for testing when WM already launched

  CURRENT_WINDOW=$(pfw)

  if [[ "$WID" = "prev" ]]; then
    WID=$(lsw | grep -v "$CURRENT_WINDOW" | sed '$ p;d')
  elif  [[ "$WID" = "next" ]]; then
    WID=$(lsw | grep -v "$CURRENT_WINDOW" | sed '1 p;d')
  fi

  if [[ "$WID" != "" ]]; then
    # put it on top of the stack
    chwso -r "$WID"
    # set focus to it
    wtf "$WID"

    # resize "$WID"
  fi
}

function resize() {
  ROOT=$(lsw -r)
  SCREEN_WIDTH=$(wattr w "$ROOT")
  SCREEN_HEIGHT=$(wattr h "$ROOT")

  wtp 0 0 "$SCREEN_WIDTH" "$SCREEN_HEIGHT" "$WID"
}

while IFS=: read -r ev wid; do
  # XCB_CREATE_NOTIFY ...... 16
  # XCB_DESTROY_NOTIFY ..... 17
  # XCB_UNMAP_NOTIFY ....... 18
  # XCB_MAP_NOTIFY ......... 19

  if [[ "$ev" = "16" ]]; then
    wattr o "$wid" || :
  elif [[ "$ev" = "18" ]]; then
    focus prev
  elif [[ "$ev" = "19" ]]; then
    focus "$wid"
  fi
done
