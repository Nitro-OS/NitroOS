#!/usr/bin/env bash

choice=$(printf "⏻ Shutdown\n Reboot\n Suspend\n Lock\n Logout" | \
rofi -dmenu -i -p "Power" -location 3 -yoffset 40 -width 20)

case "$choice" in
  "⏻ Shutdown") systemctl poweroff ;;
  " Reboot") systemctl reboot ;;
  " Suspend") systemctl suspend ;;
  " Lock") hyprlock ;;
  " Logout") hyprctl dispatch exit ;;
esac
