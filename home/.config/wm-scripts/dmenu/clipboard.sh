#!/usr/bin/env bash

if pgrep -x fuzzel > /dev/null; then
    pkill -x fuzzel
    exit 0
fi

# 发送通知
notify() {
    notify-send -a "clipboard" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

selection=$(cliphist list | fuzzel --dmenu)

[[ -z "$selection" ]] && exit 0

if echo "$selection" | cliphist decode | wl-copy; then
    notify "Copied"
else
    notify "??? Failed"
    exit 1
fi
