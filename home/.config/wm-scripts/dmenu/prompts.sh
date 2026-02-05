#!/usr/bin/env bash

if pgrep -x fuzzel > /dev/null; then
    pkill -x fuzzel
    exit 0
fi

# 发送通知
notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-canonical-private-synchronous:vis \
                "$1"
}

prompts_path="$HOME/Documents/notes/prompts"

choice=$(ls -1 "$prompts_path" | fuzzel --dmenu)

# 如果按 Esc 退出, 则脚本结束
[[ -z "$choice" ]] && exit 0

if wl-copy < "$prompts_path/$choice"; then
    notify "Copied"
else
    notify "ERROR"
    exit 1
fi
