#!/usr/bin/env bash

if pgrep -x slurp > /dev/null; then
    pkill -x slurp
    exit 0
fi

output_dir="$HOME/Pictures/screen_shots"

mkdir -p "$output_dir"

output_file="$output_dir/shot_$(date +'%y%m%d_%H%M%S').png"

# 发送通知
notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-canonical-private-synchronous:vis \
                "$1"
}

case "$1" in
    "area-save")
        geometry=$(slurp -b 0ABAB540)
        if [[ -n "$geometry" ]]; then
            grim -g "$geometry" "$output_file"
        else
            notify "Cancelled"
        fi
        ;;
    "full-save")
        grim "$output_file"
        ;;
    "area-copy")
        geometry=$(slurp -b 0ABAB540)
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
