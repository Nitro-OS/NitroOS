#!/bin/bash

CACHE="$HOME/.cache/current_wallpaper"

if [[ -f "$CACHE" ]]; then
    awww img "$(cat "$CACHE")" \
        --transition-type simple \
        --transition-duration 0
fi
