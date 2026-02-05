#!/usr/bin/env bash

# 发送通知
notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

# 使用 slurp 选择一个像素点
# -p: 选择点而不是区域
# -b: 设置选择时的背景颜色: 全透明
GEOMETRY=$(slurp -p -b 00000000)

# 如果用户按 ESC 取消, 直接退出
if [[ -z "$GEOMETRY" ]]; then
    notify "Cancelled"
    exit 0
fi

COLOR=$(grim -g "$GEOMETRY" -t ppm - | magick - -format '%[hex:u]' info:-)

FINAL_COLOR="#$(echo "$COLOR" | cut -c 1-6)"

# 复制到剪贴板, -n: 不带换行符
echo -n "$FINAL_COLOR" | wl-copy

notify "Picked"
