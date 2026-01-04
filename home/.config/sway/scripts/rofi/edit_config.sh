#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# 依赖检查
if ! command -v "code" &> /dev/null; then
    printf "Error: Missing dependency: code\n" >&2
    exit 1
fi

declare -A configs
configs["hypr"]="$HOME/.config/hypr"
configs["sway"]="$HOME/.config/sway"
configs["rofi"]="$HOME/.config/rofi"
configs["waybar"]="$HOME/.config/waybar"
configs["lf"]="$HOME/.config/lf"
configs["mako"]="$HOME/.config/mako"
configs["navi"]="$HOME/.config/navi"
configs["kitty"]="$HOME/.config/kitty"
configs["foot"]="$HOME/.config/foot"
configs["fcitx5"]="$HOME/.local/share/fcitx5"
configs["fastfetch"]="$HOME/.config/fastfetch"
configs["lain"]="$HOME/.lain"
configs["lain-bin"]="$HOME/.lain/bin"
configs["lain-lib"]="$HOME/.lain/lib"

configs["tidy"]="/workspace/dev/yz-dots/tidy"
configs["bootstrap"]="/workspace/dev/yz-dots/bootstrap"

config_choice=$(printf "%s\n" "${!configs[@]}" | rofi -dmenu -i -p "config" -theme ~/.config/rofi/themes/edit_config.rasi)

# 如果按 Esc 退出，则脚本结束
if [[ -z "$config_choice" ]]; then
    exit 0
fi

config_path=${configs[$config_choice]}

real_path=$(readlink -f "$config_path")

code "$real_path"
