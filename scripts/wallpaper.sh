#!/bin/bash

set -u

REPO="https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main"

# Persistent data
DATA="$HOME/.cache/aesthetic-wallpaper"
LIST="$DATA/wallpapers.list"
USED="$DATA/used.list"

# Temporary downloaded image
TMP="/tmp/aesthetic-wallpaper"
CURRENT="$TMP/current"

CACHE_TIME=86400       # Refresh GitHub list every 24 hours
INTERVAL=1800          # 30 minutes

mkdir -p "$DATA" "$TMP"

get_wallpaper_list() {
    echo "Updating wallpaper list..."

    TEMP="$DATA/wallpapers.tmp"

    : > "$TEMP"

    for page in $(seq 1 15); do
        curl -fsSL \
            --retry 3 \
            --connect-timeout 10 \
            "$REPO/pages/Page${page}.md" |
            grep -oE 'https://raw.githubusercontent.com/[^") ]+\.(jpg|jpeg|png|webp)' \
            >> "$TEMP"
    done

    sort -u "$TEMP" > "$LIST"
    rm -f "$TEMP"

    echo "Found $(wc -l < "$LIST") wallpapers."
}

# Update wallpaper list once every 24 hours
if [ ! -f "$LIST" ] ||
   [ $(( $(date +%s) - $(stat -c %Y "$LIST") )) -ge "$CACHE_TIME" ]; then
    get_wallpaper_list
fi

if [ ! -s "$LIST" ]; then
    echo "No wallpapers found."
    exit 1
fi

touch "$USED"

while true; do

    # Remove wallpapers from history that no longer exist
    comm -12 \
        <(sort "$LIST") \
        <(sort -u "$USED") > "$USED.tmp"

    mv "$USED.tmp" "$USED"

    TOTAL=$(wc -l < "$LIST")
    USED_COUNT=$(wc -l < "$USED")

    # Start a new cycle when everything has been used
    if [ "$USED_COUNT" -ge "$TOTAL" ]; then
        echo "All wallpapers used. Starting a new cycle."
        : > "$USED"
    fi

    # Pick an unused wallpaper
    NEW_URL=$(
        comm -23 \
            <(sort "$LIST") \
            <(sort -u "$USED") |
        shuf -n 1
    )

    if [ -z "$NEW_URL" ]; then
        echo "Could not select wallpaper."
        sleep 60
        continue
    fi

    echo
    echo "Selected:"
    echo "$NEW_URL"

    EXT="${NEW_URL##*.}"

    FILE="$TMP/wallpaper.$EXT"
    DOWNLOAD="$TMP/download.$EXT"

    # Download only the selected image
    if curl -fL \
        --retry 3 \
        --connect-timeout 10 \
        "$NEW_URL" \
        -o "$DOWNLOAD"; then

        if feh --no-fehbg --bg-fill "$DOWNLOAD"; then

            # Add to persistent history
            echo "$NEW_URL" >> "$USED"

            # Remember current wallpaper
            printf '%s\n' "$NEW_URL" > "$CURRENT"

            # Replace old image
            mv -f "$DOWNLOAD" "$FILE"

            echo "Wallpaper changed."
            echo "Progress: $(wc -l < "$USED") / $TOTAL"

        else
            echo "feh failed."
            rm -f "$DOWNLOAD"
        fi

    else
        echo "Download failed."
        rm -f "$DOWNLOAD"
    fi

    echo "Next wallpaper in 30 minutes."
    sleep "$INTERVAL"
done
