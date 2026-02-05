#!/usr/bin/env bash

if pgrep -x slurp > /dev/null; then
    pkill -x slurp
    exit 0
fi

# 发送通知
notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-canonical-private-synchronous:vis \
                "$1"
}

# 使用 slurp 选择一个像素点
# -p: 选择点而不是区域
# -b: 设置选择时的背景颜色: 全透明
geometry=$(slurp -p -b 00000000)

# 如果用户按 ESC 取消, 直接退出
if [[ -z "$geometry" ]]; then
    notify "Cancelled"
    exit 0
fi

color=$(grim -g "$geometry" -t ppm - | magick - -format '%[hex:u]' info:-)

final_color="#$(echo "$color" | cut -c 1-6)"

# 复制到剪贴板, -n: 不带换行符
echo -n "$final_color" | wl-copy

notify "Picked"
