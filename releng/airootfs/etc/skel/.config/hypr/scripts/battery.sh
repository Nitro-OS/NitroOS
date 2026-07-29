#!/bin/sh

capacity=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1)

if [ "$status" = "Charging" ]; then
    icon="󰂄"
elif [ "$capacity" -le 10 ]; then
    icon="󰂃"
elif [ "$capacity" -le 20 ]; then
    icon="󰁺"
elif [ "$capacity" -le 30 ]; then
    icon="󰁻"
elif [ "$capacity" -le 40 ]; then
    icon="󰁼"
elif [ "$capacity" -le 50 ]; then
    icon="󰁽"
elif [ "$capacity" -le 60 ]; then
    icon="󰁾"
elif [ "$capacity" -le 70 ]; then
    icon="󰁿"
elif [ "$capacity" -le 80 ]; then
    icon="󰂀"
elif [ "$capacity" -le 90 ]; then
    icon="󰂁"
else
    icon="󰂂"
fi

echo "$icon $capacity%"
