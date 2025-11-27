#!/usr/bin/env bash

set -euo pipefail

output_dir="$HOME/Videos"

# 检查是否已经在运行, 或者 pgrep -f
if killall -0 "gpu-screen-recorder" 2>/dev/null; then
    notify-send -a "recorder" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "Already recording."
    printf "recording in progress.\n"
    exit 1
fi

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

# 发送录制结束的通知
notify-send -a "recorder" \
            -u low \
            -h string:x-dunst-stack-tag:volume_notif \
            "Stop recording"

printf "Done.\n"
