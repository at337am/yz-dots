#!/usr/bin/env bash

set -euo pipefail

output_dir="$HOME/Videos"

# 检查是否已经在运行, 或者 pgrep -f
if killall -0 "gpu-screen-recorder" > /dev/null; then
    notify-send -a "recording" \
            # -u low \
            -h string:x-dunst-stack-tag:volume_notif \
            "录制失败" \
            "GPU Screen Recorder 已经在运行中！"
    exit 1
fi

mkdir -p "$output_dir"
output_file="$output_dir/recording_$(date +"%y%m%d_%H%M%S").mp4"

# 发送录制通知
notify-send -a "recording" \
            -u low \
            -h string:x-dunst-stack-tag:volume_notif \
            "Start recording..."

gpu-screen-recorder -w screen -f 60 -a "default_output|default_input" -o "$output_file"

# 发送录制结束的通知
notify-send -a "recording" \
            -u low \
            -h string:x-dunst-stack-tag:volume_notif \
            "Stop recording"

printf "Done.\n"
