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

# 发送录制通知
notify-send -a "recorder" \
            -u low \
            -h string:x-dunst-stack-tag:volume_notif \
            "Start recording..."

# 全屏录制, 60帧, 速率控制 CBR, 码率 15000, 混合音频, 减少输出信息
gpu-screen-recorder -w screen \
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
            "Stop recording."

printf "Done.\n"
