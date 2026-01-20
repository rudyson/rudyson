#!/bin/sh

# Keyboard switcher
setxkbmap -model pc105 -layout us,ru,ua -option grp:alt_shift_toggle -option grp:win_space_toggle -option compose:ralt

# Starting Windows Manager
exec i3
