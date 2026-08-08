#!/usr/bin/env bash
# ▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖      ▗▄▖  ▗▄▄▖
# ▐▛▚▖▐▌  █    █  ▐▌ ▐▌▐▌ ▐▌    ▐▌ ▐▌▐▌   
# ▐▌ ▝▜▌  █    █  ▐▛▀▚▖▐▌ ▐▌    ▐▌ ▐▌ ▝▀▚▖
# ▐▌  ▐▌▗▄█▄▖  █  ▐▌ ▐▌▝▚▄▞▘    ▝▚▄▞▘▗▄▄▞▘
# Github : @Nitro-OS

ROFI_HELP_DIR="$HOME/.config/rofi/help"
HYPR_DIR="$HOME/.config/hypr"

header=$(printf "<b>%-35s │ %s</b>" "COMMAND" "DESCRIPTION")

python3 "$ROFI_HELP_DIR/parse_bindings.py" "$HYPR_DIR/keybindings.conf" "$ROFI_HELP_DIR/commands.json" | rofi -dmenu -i \
    -theme "$ROFI_HELP_DIR/style.rasi" \
    -p "" \
    -mesg "$header" \
    -markup-rows
