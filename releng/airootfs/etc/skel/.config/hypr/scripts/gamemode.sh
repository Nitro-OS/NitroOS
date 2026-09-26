#!/usr/bin/env bash

STATE_FILE="/tmp/hypr_gamemode.state"

HYPR_ANIM_STATE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPR_ANIM_STATE" = "true" ] || [ "$HYPR_ANIM_STATE" = "1" ] && [ ! -f "$STATE_FILE" ]; then
    hyprctl eval '
      hl.config({
        animations = { enabled = false },
        decoration = {
          rounding = 0,
          active_opacity = 1.0,
          inactive_opacity = 1.0,
          fullscreen_opacity = 1.0,
          dim_inactive = false,
          shadow = { enabled = false },
          blur = { enabled = false },
        },
        general = {
          gaps_in = 0,
          gaps_out = 0,
          border_size = 1,
          allow_tearing = true,
        },
        misc = {
          vrr = 1,
        }
      })
    ' >/dev/null 2>&1 || hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:active_opacity 1.0;\
        keyword decoration:inactive_opacity 1.0;\
        keyword decoration:fullscreen_opacity 1.0;\
        keyword decoration:rounding 0;\
        keyword decoration:dim_inactive 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword general:allow_tearing 1;\
        keyword misc:vrr 1" >/dev/null 2>&1 || true

    pkill -STOP hypridle 2>/dev/null || true

    touch "$STATE_FILE"

    notify-send -u low -i "input-gaming" "Game Mode" "Enabled - animations, effects & idle lock disabled" 2>/dev/null || true

    if command -v makoctl >/dev/null 2>&1; then
        makoctl mode -a dnd >/dev/null 2>&1 || true
    fi

    pkill -RTMIN+8 waybar 2>/dev/null || true

else
    if command -v makoctl >/dev/null 2>&1; then
        makoctl mode -r dnd >/dev/null 2>&1 || true
    fi

    pkill -CONT hypridle 2>/dev/null || true

    rm -f "$STATE_FILE"

    hyprctl reload >/dev/null 2>&1 || true

    notify-send -u low -i "input-gaming" "Game Mode" "Disabled - default settings restored" 2>/dev/null || true

    pkill -RTMIN+8 waybar 2>/dev/null || true
fi
