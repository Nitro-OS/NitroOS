#!/usr/bin/env bash
# ▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖      ▗▄▖  ▗▄▄▖
# ▐▛▚▖▐▌  █    █  ▐▌ ▐▌▐▌ ▐▌    ▐▌ ▐▌▐▌   
# ▐▌ ▝▜▌  █    █  ▐▛▀▚▖▐▌ ▐▌    ▐▌ ▐▌ ▝▀▚▖
# ▐▌  ▐▌▗▄█▄▖  █  ▐▌ ▐▌▝▚▄▞▘    ▝▚▄▞▘▗▄▄▞▘
# Github : @Nitro-OS

dir="$HOME/.config/rofi/powermenu"
theme="style"

uptime=$(uptime -p | sed 's/up //')
host=$(hostname)

shutdown=" Shutdown"
reboot=" Reboot"
lock=" Lock"
suspend=" Suspend"
logout=" Logout"

yes=" Yes"
no=" No"

rofi_cmd() {
    rofi -dmenu -i \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme "$dir/$theme.rasi"
}

confirm_cmd() {
    rofi -dmenu -i \
        -p "Confirmation" \
        -mesg "Are you sure?" \
        -theme "$dir/$theme.rasi" \
        -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox {children: ["message","listview"];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}'
}

confirm_exit() {
    printf "%s\n%s\n" "$yes" "$no" | confirm_cmd
}

run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s\n" \
        "$lock" \
        "$suspend" \
        "$logout" \
        "$reboot" \
        "$shutdown" | rofi_cmd
}

run_cmd() {
    [[ "$(confirm_exit)" != "$yes" ]] && exit 0

    case "$1" in
        --shutdown)
            systemctl poweroff
            ;;
        --reboot)
            systemctl reboot
            ;;
        --suspend)
            systemctl suspend
            ;;
        --logout)
            hyprctl dispatch exit
            ;;
    esac
}

chosen="$(run_rofi)"

case "$chosen" in
    "$shutdown")
        run_cmd --shutdown
        ;;
    "$reboot")
        run_cmd --reboot
        ;;
    "$lock")
        (
            sleep 0.1
            exec hyprlock
        ) &
        exit 0
        ;;
    "$suspend")
        run_cmd --suspend
        ;;
    "$logout")
        run_cmd --logout
        ;;
esac
