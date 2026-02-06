#!/usr/bin/env bash

# 新增一个配置文件可能要注意:
# 1. 拷贝配置到 yz-dots/home
# 2. bootstrap - symlink_dotfiles.sh
# 4. bootstrap - pacman_install.sh
# 3. wm-scripts - edit_config.sh
# 5. 最后, 执行一次 tidy/reset/home.sh 脚本

if pgrep -x fuzzel > /dev/null; then
    pkill -x fuzzel
    exit 0
fi

# 依赖检查
if ! command -v "code" &> /dev/null; then
    printf "Error: Missing dependency: code\n" >&2
    exit 1
fi

# 发送通知
notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-canonical-private-synchronous:vis \
                "$1"
}

declare -A configs
# configs["hypr"]="$HOME/.config/hypr"
# configs["sway"]="$HOME/.config/sway"
configs["river"]="$HOME/.config/river"
configs["wm-scripts"]="$HOME/.config/wm-scripts"
configs["swaylock"]="$HOME/.config/swaylock"
configs["swayidle"]="$HOME/.config/swayidle"
configs["kanshi"]="$HOME/.config/kanshi"
configs["fuzzel"]="$HOME/.config/fuzzel"
configs["waybar"]="$HOME/.config/waybar"
configs["wob"]="$HOME/.config/wob"
configs["lf"]="$HOME/.config/lf"
configs["mako"]="$HOME/.config/mako"
configs["navi"]="$HOME/.config/navi"
configs["kitty"]="$HOME/.config/kitty"
configs["foot"]="$HOME/.config/foot"
configs["fcitx5"]="$HOME/.local/share/fcitx5"
configs["applications"]="$HOME/.local/share/applications"
configs["fastfetch"]="$HOME/.config/fastfetch"
configs["lain"]="$HOME/.lain"
configs["lain-bin"]="$HOME/.lain/bin"

configs["tidy"]="/workspace/dev/yz-dots/tidy"
configs["bootstrap"]="/workspace/dev/yz-dots/bootstrap"

configs["skit-dirhash"]="/workspace/dev/skit/dirhash"
configs["skit-gonew"]="/workspace/dev/skit/gonew"
configs["skit-md2pg"]="/workspace/dev/skit/md2pg"
configs["skit-siho"]="/workspace/dev/skit/siho"
configs["skit-tmrn"]="/workspace/dev/skit/tmrn"
configs["skit-vid2mp4"]="/workspace/dev/skit/vid2mp4"
configs["skit-xla"]="/workspace/dev/skit/xla"

configs["raindrop"]="/workspace/dev/raindrop"
configs["hello"]="/workspace/dev/hello"

configs["notes"]="$HOME/Documents/notes"

choice=$(printf "%s\n" "${!configs[@]}" | fuzzel --dmenu)

# 如果按 Esc 退出, 则脚本结束
[[ -z "$choice" ]] && exit 0

config_path=${configs[$choice]}

# 如果路径不存在, 则直接报错
if [[ ! -e "$config_path" ]]; then
    notify "ERROR"
    exit 1
fi

real_path=$(readlink -f "$config_path")

exec code "$real_path"
