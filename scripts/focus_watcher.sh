#!/bin/bash
#
# depends on: wew focus.sh

set -x
wew | while IFS=: read ev wid; do
    if [[ "$ev" = "19" ]]; then
        wattr o $wid || focus.sh $wid
    elif [[ "$ev" = "17" ]]; then
        focus.sh prev
    fi
done
