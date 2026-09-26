#!/usr/bin/env bash
# ▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖      ▗▄▖  ▗▄▄▖
# ▐▛▚▖▐▌  █    █  ▐▌ ▐▌▐▌ ▐▌    ▐▌ ▐▌▐▌   
# ▐▌ ▝▜▌  █    █  ▐▛▀▚▖▐▌ ▐▌    ▐▌ ▐▌ ▝▀▚▖
# ▐▌  ▐▌▗▄█▄▖  █  ▐▌ ▐▌▝▚▄▞▘    ▝▚▄▞▘▗▄▄▞▘
# Github : @Nitro-OS

ROFI_HELP_DIR="$HOME/.config/rofi/help"
JSON_FILE="$ROFI_HELP_DIR/keybindings.json"

header=$(printf "<b>%-35s │ %s</b>" "KEYBINDING" "DESCRIPTION")

jq -r 'to_entries[] | "\(.key)\t\(.value)"' "$JSON_FILE" | while IFS=$'\t' read -r key desc; do
    printf "%-35s │ %s\n" "$key" "$desc"
done | rofi -dmenu -i \
    -theme "$ROFI_HELP_DIR/style.rasi" \
    -p "" \
    -mesg "$header" \
    -markup-rows
