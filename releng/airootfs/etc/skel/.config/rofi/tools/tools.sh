#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
theme="$SCRIPT_DIR/tools-style.rasi"

selected_row=0

while true; do
    temp=$(hyprctl hyprsunset temperature 2>/dev/null)
    if [[ -n "$temp" && "$temp" =~ ^[0-9]+$ && "$temp" -lt 6000 ]]; then
        night_badge="[ ON ]"
        night_icon="󰖔"
    else
        night_badge="[ OFF ]"
        night_icon="󰖨"
    fi

    STATE_FILE="/tmp/hypr_gamemode.state"
    HYPR_ANIM=$(hyprctl getoption animations:enabled 2>/dev/null | awk 'NR==1{print $2}')
    if [ -f "$STATE_FILE" ] || [ "$HYPR_ANIM" = "false" ] || [ "$HYPR_ANIM" = "0" ]; then
        game_badge="[ ON ]"
        game_icon="󰊴"
    else
        game_badge="[ OFF ]"
        game_icon="󰊴"
    fi

    if makoctl mode 2>/dev/null | grep -q "dnd"; then
        dnd_badge="[ ON ]"
        dnd_icon="󰂛"
    else
        dnd_badge="[ OFF ]"
        dnd_icon="󰂚"
    fi

    clip_badge="[ Open ]"
    clip_icon="󰅌"
    color_badge="[ Pick ]"
    color_icon="󰈊"
    snip_badge="[ Snip ]"
    snip_icon="󰄀"
    full_badge="[ Save ]"
    full_icon="󰅍"

    opt_night=$(printf "%-26s %s" "$night_icon  Night Mode" "$night_badge")
    opt_game=$(printf "%-26s %s" "$game_icon  Game Mode" "$game_badge")
    opt_dnd=$(printf "%-26s %s" "$dnd_icon  Do Not Disturb" "$dnd_badge")
    opt_clip=$(printf "%-26s %s" "$clip_icon  Clipboard History" "$clip_badge")
    opt_color=$(printf "%-26s %s" "$color_icon  Color Picker" "$color_badge")
    opt_snip=$(printf "%-26s %s" "$snip_icon  Area Screenshot" "$snip_badge")
    opt_full=$(printf "%-26s %s" "$full_icon  Full Screenshot" "$full_badge")

    chosen=$(printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
        "$opt_night" \
        "$opt_game" \
        "$opt_dnd" \
        "$opt_clip" \
        "$opt_color" \
        "$opt_snip" \
        "$opt_full" | rofi \
        -theme "$theme" \
        -dmenu \
        -i \
        -selected-row "$selected_row" \
        -p "Quick Tools" \
        -markup-rows)

    exit_code=$?

    if [ $exit_code -ne 0 ] || [ -z "$chosen" ]; then
        break
    fi

    case "$chosen" in
        *"Night Mode"*)
            selected_row=0
            if [ -x "$SCRIPT_DIR/hyprsunset-toggle.sh" ]; then
                "$SCRIPT_DIR/hyprsunset-toggle.sh"
            elif [[ -n "$temp" && "$temp" =~ ^[0-9]+$ ]] && (( temp < 6000 )); then
                hyprctl hyprsunset temperature 6500
            else
                hyprctl hyprsunset temperature 4500
            fi
            ;;
        *"Game Mode"*)
            selected_row=1
            if [ -x "$HOME/.config/hypr/scripts/gamemode.sh" ]; then
                "$HOME/.config/hypr/scripts/gamemode.sh"
            fi
            ;;
        *"Do Not Disturb"*)
            selected_row=2
            makoctl mode -t dnd
            if makoctl mode 2>/dev/null | grep -q "dnd"; then
                notify-send "Do Not Disturb" "Enabled (Notifications muted)" -u low 2>/dev/null
            else
                notify-send "Do Not Disturb" "Disabled (Notifications active)" -u low 2>/dev/null
            fi
            ;;
        *"Clipboard History"*)
            (
                sleep 0.1
                if [ -x "$HOME/.config/rofi/clipboard/clipboard.sh" ]; then
                    "$HOME/.config/rofi/clipboard/clipboard.sh"
                else
                    cliphist list | rofi -dmenu -theme "$theme" -p "Clipboard" | cliphist decode | wl-copy
                fi
            ) &
            break
            ;;
        *"Color Picker"*)
            (
                sleep 0.2
                color=$(hyprpicker -a 2>/dev/null)
                if [ -n "$color" ]; then
                    notify-send "Color Picker" "Copied $color to clipboard" -u low 2>/dev/null
                fi
            ) &
            break
            ;;
        *"Area Screenshot"*)
            (
                sleep 0.2
                mkdir -p "$HOME/Pictures/Screenshots"
                file="$HOME/Pictures/Screenshots/Screenshot_$(date +%Y%m%d_%H%M%S).png"
                grim -g "$(slurp)" "$file" 2>/dev/null
                if [ -f "$file" ]; then
                    wl-copy < "$file" 2>/dev/null
                    notify-send "Screenshot Captured" "Saved to ~/Pictures/Screenshots and copied to clipboard" -i "$file" -u low 2>/dev/null
                fi
            ) &
            break
            ;;
        *"Full Screenshot"*)
            (
                sleep 0.3
                mkdir -p "$HOME/Pictures/Screenshots"
                file="$HOME/Pictures/Screenshots/Screenshot_$(date +%Y%m%d_%H%M%S).png"
                grim "$file" 2>/dev/null
                if [ -f "$file" ]; then
                    wl-copy < "$file" 2>/dev/null
                    notify-send "Screenshot Captured" "Saved to ~/Pictures/Screenshots and copied to clipboard" -i "$file" -u low 2>/dev/null
                fi
            ) &
            break
            ;;
        *)
            break
            ;;
    esac

    sleep 0.1
done
