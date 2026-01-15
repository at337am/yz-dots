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

prompts_path="$HOME/Documents/notes/prompts"

[[ ! -d "$prompts_path" ]] && exit 1

selection=$(ls -1 "$prompts_path" | fuzzel --dmenu)

[[ -z "$selection" ]] && exit 0

if wl-copy < "$prompts_path/$selection"; then
    notify "Copied"
else
    notify "??? Failed"
    exit 1
fi
