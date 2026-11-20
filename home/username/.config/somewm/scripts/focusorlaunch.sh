#!/bin/sh
class=$1
shift

# Exec=(...)/somewm/scripts/focusorlaunch.sh btop kitty --class btop btop

window_id=$(somewm-client client list |
  grep -F "class=\"$class\"" |
  sed -n '1s/^id=\([0-9]*\).*/\1/p')
window_tag=$(somewm-client client list |
  grep -F "class=\"$class\"" |
  sed -n '1s/.*tags=\([0-9]*\).*/\1/p')

if [ -n "$window_id" ]; then
  somewm-client client focus "$window_id"
  somewm-client tag toggle "$window_tag"
  # notify-send "$window_tag"
else
  "$@" &
fi
