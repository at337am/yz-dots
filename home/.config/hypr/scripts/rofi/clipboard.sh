#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# 发送通知
notify() {
    notify-send -a "clipboard" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

selection=$(cliphist list | rofi -dmenu -i -p "clipboard")

[[ -z "$selection" ]] && exit 0

if echo "$selection" | cliphist decode | wl-copy; then
    notify "Copied"
else
    notify "Copy Failed"
    exit 1
fi
