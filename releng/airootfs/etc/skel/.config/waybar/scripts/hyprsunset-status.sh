#!/bin/bash

temp=$(hyprctl hyprsunset temperature 2>/dev/null)

if [ -z "$temp" ] || ! [[ $temp =~ ^[0-9]+$ ]]; then
  echo '{"text": "?", "tooltip": "Hyprsunset: Not running", "class": "unavailable"}'
else
  if (( temp < 6000 )); then
    echo '{"text": "󰖨 OFF", "tooltip": "Hyprsunset: ON ('"$temp"'K)", "class": "on"}'
  else
    echo '{"text": "󰖔 ON", "tooltip": "Hyprsunset: OFF ('"$temp"'K)", "class": "off"}'
  fi
fi
