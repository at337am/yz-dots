#!/usr/bin/env bash

set -euo pipefail

output_dir="$HOME/Videos"

# 检查是否已经在运行, 或者 pgrep -f
if killall -0 "gpu-screen-recorder" 2>/dev/null; then
    notify-send -a "recording" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "already recording"
    printf "recording in progress.\n"
    exit 1
fi

mkdir -p "$output_dir"
output_file="$output_dir/recording_$(date +"%y%m%d_%H%M%S").mkv"

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
