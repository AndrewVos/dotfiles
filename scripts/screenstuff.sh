#!/bin/bash

set -x

## CONFIGURATION

# Set the border color
bordercolor=EEEEEE

# Set the border size
bordersize=10

# Set wmutils location
wmutilsdir="/tmp/wmutils"


## EXECUTE

# Create wmutils dir
mkdir -p "$wmutilsdir/desktop"

# Initialize desktop
echo "1" > "$wmutilsdir/desktop/active"
cat "/dev/null" > "$wmutilsdir/desktop/1"
cat "/dev/null" > "$wmutilsdir/desktop/2"
cat "/dev/null" > "$wmutilsdir/desktop/3"

# Start lemonbars
# bash "$HOME/.lemonbar/clock.sh" &
# bash "$HOME/.lemonbar/desktop.sh" &
# bash "$HOME/.lemonbar/music.sh" &
# bash "$HOME/.lemonbar/window.sh" &

# Fix lemonbars
# sleep 0.5
# bash "$HOME/.wmutils/desktop.sh" 1

wew | \
while IFS=: read ev wid; do
	# Ignore ignored windows
	wattr o "$wid"
	if [[ "$?" -eq 0 ]]; then
		continue
	fi

	case "$ev" in
		# Enter/leave events
		7)
			# Focus window
			wtf "$wid"
			;;
		# Create window event
		16)
			# Give the window a border
			chwb -c 0x$bordercolor -s $bordersize "$wid"

			# Spawn the window under cursor
			wmv -a $(wmp) "$wid"

			# Echo wid to file
			active="$(cat "$wmutilsdir/desktop/active")"
			echo "$wid" >> "$wmutilsdir/desktop/$active"
			;;
		# Close window event
		17)
			# Remove wid from file
			active="$(cat "$wmutilsdir/desktop/active")"
			sed -i "/$wid/d" "$wmutilsdir/desktop/$active"
			;;
		# Map window event
		19)
			# Do nothing if last event was not 16
			if [[ "$lastev" != "16:$wid" ]]; then
				continue
			fi

			# Spawn the window under cursor (again, for slower windows like mpv)
			wmv -a $(wmp) "$wid"
			
			# Create some vars for the next 2 parts
			wheight="$(wattr h "$wid")"
			wwidth="$(wattr w "$wid")"
			cursorx="$(wmp | cut -d " " -f 2)"

			# Move window down if spawned on lemonbar
			if [[ "$((cursorx - (wheight / 2) + bordersize))" -le 28 ]] && [[ "$wheight" -ne 1200 ]] && [[ "$wwidth" -ne 1920 ]]; then
				wmv 0 28 "$wid"
			fi

			# Remove borders if fullscreen
			if [[ "$wheight" -eq 1200 ]] && [[ "$wwidth" -eq 1920 ]]; then
				chwb -s 0 "$wid"
				wmv -a 0 0 "$wid"
			fi
			;;
	esac

	# Save current event for next event (needed by 19)
	lastev="$ev:$wid"
done
