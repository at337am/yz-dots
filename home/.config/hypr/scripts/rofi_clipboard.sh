#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

cliphist list | rofi -dmenu -i -p "clipboard" | cliphist decode | wl-copy

# todo: fix 取消时, 依然提示 Copied
# if cliphist list | rofi -dmenu -p "clipboard" | cliphist decode | wl-copy; then
#     notify-send -a "clipboard" \
#                 -u low \
#                 -h string:x-dunst-stack-tag:volume_notif \
#                 "📋  Copied"
# else
#     notify-send -a "clipboard" \
#                 -u low \
#                 -h string:x-dunst-stack-tag:volume_notif \
#                 "Copy Failed"
# fi
