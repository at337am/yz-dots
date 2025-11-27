#!/usr/bin/env bash

# 区域录制

set -euo pipefail

# 检查是否已经在运行
if pgrep -f "gpu-screen-recorder" > /dev/null; then

    # -2 相当于 Ctrl + C
    pkill -2 -f "gpu-screen-recorder"

    notify-send -a "recorder" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "Stop recording"
    exit 0
fi

output_dir="$HOME/Videos"
mkdir -p "$output_dir"
output_file="$output_dir/recorder_$(date +"%y%m%d_%H%M%S").mkv"

GEOMETRY=$(slurp -f '%wx%h+%x+%y')

# 判断是否取消
if [[ -z "$GEOMETRY" ]]; then
    notify-send -a "recorder" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "Canceled"
    exit 1
fi

# 发送录制通知
notify-send -a "recorder" \
            -u low \
            -h string:x-dunst-stack-tag:volume_notif \
            "Start recording..."

# 开始区域录制
gpu-screen-recorder \
            -w region \
            -region "$GEOMETRY" \
            -f 60 \
            -bm cbr \
            -q 15000 \
            -a "default_output|default_input" \
            -v no \
            -o "$output_file"
