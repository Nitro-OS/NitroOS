#!/bin/bash

temp=$(hyprctl hyprsunset temperature 2>/dev/null)

if [ -z "$temp" ] || ! [[ $temp =~ ^[0-9]+$ ]]; then
  notify-send "Hyprsunset" "Daemon not running" -u low
  exit 1
elif (( temp >= 6000 )); then
  hyprctl hyprsunset temperature 4500
else
  hyprctl hyprsunset temperature 6500
fi
