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

notes_path="$HOME/Documents/notes/prompts"

[[ ! -d "$notes_path" ]] && exit 1

selected_file=$( (cd "$notes_path" && ls -1) | rofi -dmenu -i -p "prompts" -theme ~/.config/rofi/themes/prompts.rasi)

[[ -z "$selected_file" ]] && exit 0

full_path="$notes_path/$selected_file"

if [[ -f "$full_path" ]]; then
    wl-copy < "$full_path"
    notify "Copied"
else
    notify "Copy Failed"
    exit 1
fi
