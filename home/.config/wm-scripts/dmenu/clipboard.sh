#!/usr/bin/env bash

if pgrep -x fuzzel > /dev/null; then
    pkill -x fuzzel
    exit 0
fi

# 发送通知
notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

choice=$(cliphist list | fuzzel --dmenu)

# 如果按 Esc 退出, 则脚本结束
[[ -z "$choice" ]] && exit 0

if echo "$choice" | cliphist decode | wl-copy; then
    notify "Copied"
else
    notify "ERROR"
    exit 1
fi
