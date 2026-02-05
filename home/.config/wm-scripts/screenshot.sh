#!/usr/bin/env bash

if pgrep -x slurp > /dev/null; then
    pkill -x slurp
    exit 0
fi

output_dir="$HOME/Pictures/Screenshots"

mkdir -p "$output_dir"

file_path="$output_dir/$(date +'%y%m%d_%H%M%S').png"

notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

case "$1" in
    "area-save")
        geometry=$(slurp)
        if [[ -n "$geometry" ]]; then
            grim -g "$geometry" "$file_path"
        else
            notify "Cancelled"
        fi
        ;;
    "full-save")
        grim "$file_path"
        ;;
    "area-copy")
        geometry=$(slurp)
        if [[ -n "$geometry" ]]; then
            grim -g "$geometry" - | wl-copy -t image/png
            notify "SC Copied"
        else
            notify "Cancelled"
        fi
        ;;
    "full-copy")
        grim - | wl-copy -t image/png
        notify "SC Copied"
        ;;
    *)
        echo "用法: $0 {area-save|full-save|area-copy|full-copy}"
        exit 1
        ;;
esac
