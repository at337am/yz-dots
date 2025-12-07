#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

workspaces=$(hyprctl workspaces -j | jq -r 'sort_by(.id) | .[] | "\(.name)\t\(.lastwindowtitle)"')

chosen_index=$(echo -e "$workspaces" | rofi -dmenu -i -p "workspaces" -format 'i' -no-show-icons -kb-accept-entry 'Return' -theme ~/.config/rofi/themes/switch_workspace.rasi)

if [ -z "$chosen_index" ]; then
    exit 0
fi

target_line=$(echo -e "$workspaces" | sed -n "$((chosen_index + 1))p")

workspace_name=$(echo "$target_line" | cut -f1)

hyprctl dispatch workspace "$workspace_name"
