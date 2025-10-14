#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

declare -A configs
configs["hypr"]="$HOME/.config/hypr"
configs["rofi"]="$HOME/.config/rofi"
configs["waybar"]="$HOME/.config/waybar"
configs["mako"]="$HOME/.config/mako"
configs["navi"]="$HOME/.config/navi"
configs["kitty"]="$HOME/.config/kitty"
configs["rime"]="$HOME/.local/share/fcitx5/rime"
configs["bootstrap"]="$HOME/workspace/dev/yz-dots/bootstrap"

config_choice=$(printf "%s\n" "${!configs[@]}" | rofi -dmenu -i -p "config" -theme ~/.config/rofi/themes/edit_config.rasi)

# 如果按 Esc 退出，则脚本结束
if [[ -z "$config_choice" ]]; then
    exit 0
fi

config_path=${configs[$config_choice]}

real_path=$(readlink -f "$config_path")

command code "$real_path" --ozone-platform-hint=auto > /dev/null 2>&1
