#!/usr/bin/env bash

# 新增一个配置文件可能有四个步骤要走:
# 1. 拷贝配置到 dotfiles. (yz-dots/home)
# 2. 是否写入软链接脚本? (bootstrap/tasks/symlink_dotfiles.sh)
# 3. 是否添加到 edit_config.sh ?
# 4. bootstrap/tasks/pacman_install.sh 需要改吗?
# 5. 最后执行一次 tidy/reset/home.sh 脚本

if pgrep -x fuzzel > /dev/null; then
    pkill -x fuzzel
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
configs["river"]="$HOME/.config/river"
configs["swaylock"]="$HOME/.config/swaylock"
configs["fuzzel"]="$HOME/.config/fuzzel"
configs["waybar"]="$HOME/.config/waybar"
configs["lf"]="$HOME/.config/lf"
configs["mako"]="$HOME/.config/mako"
configs["navi"]="$HOME/.config/navi"
configs["kitty"]="$HOME/.config/kitty"
configs["foot"]="$HOME/.config/foot"
configs["alacritty"]="$HOME/.config/alacritty"
configs["fcitx5"]="$HOME/.local/share/fcitx5"
configs["fastfetch"]="$HOME/.config/fastfetch"
configs["lain"]="$HOME/.lain"
configs["lain-bin"]="$HOME/.lain/bin"

configs["tidy"]="/workspace/dev/yz-dots/tidy"
configs["bootstrap"]="/workspace/dev/yz-dots/bootstrap"

config_choice=$(printf "%s\n" "${!configs[@]}" | fuzzel --dmenu)

# 如果按 Esc 退出，则脚本结束
if [[ -z "$config_choice" ]]; then
    exit 0
fi

config_path=${configs[$config_choice]}

real_path=$(readlink -f "$config_path")

code --force-device-scale-factor=1.0 "$real_path"
