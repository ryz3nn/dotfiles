#!/bin/bash

COLOR="red"

case "$COLOR" in
    default) FG_COLOR='[97m' ;;
    red)     FG_COLOR='[38;2;255;0;0m' ;;
esac

overlay \
    -o N \
    -e 3 \
    -s 16 \
    --fg-color="$FG_COLOR" \
    --fg-alpha=255 \
    --bg-color='[48;2;5;5;5m' \
    --bg-alpha=180 \
    ~/.config/x11-overlay/text
