#!/usr/bin/env bash

status_file="/tmp/recorder_status"

# 向 waybar 发送刷新信号
refresh_waybar() {
    pkill -SIGRTMIN+8 waybar
}

# 发送通知
notify() {
    notify-send -a "recorder" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

trap 'rm -f "$status_file"; refresh_waybar' EXIT

# 检查是否已经在运行
if pgrep -f "gpu-screen-recorder" > /dev/null; then
    # -2 相当于 Ctrl + C
    pkill -2 -f "gpu-screen-recorder"

    notify "STOP REC"

    exit 0
fi

# 依赖检查
if ! command -v "gpu-screen-recorder" &> /dev/null; then
    printf "Error: Missing dependency: gpu-screen-recorder\n" >&2
    exit 1
fi

output_file="$HOME/Videos/recorder_$(date +"%y%m%d_%H%M%S").mkv"
mkdir -p "$HOME/Videos"

notify "🎀  REC"

touch "$status_file"

refresh_waybar

# 混合音轨
timeout -s 2 -k 10s 1800 gpu-screen-recorder \
            -w screen \
            -f 60 \
            -bm cbr \
            -q 15000 \
            -a "default_output|default_input" \
            -v no \
            -o "$output_file"

# # 双音轨
# timeout -s 2 -k 10s 1800 gpu-screen-recorder \
#             -w screen \
#             -f 60 \
#             -bm cbr \
#             -q 15000 \
#             -a default_output -a default_input \
#             -v no \
#             -o "$output_file"

# # 只录制系统声音
# timeout -s 2 -k 10s 1800 gpu-screen-recorder \
#             -w screen \
#             -f 60 \
#             -bm cbr \
#             -q 15000 \
#             -a default_output \
#             -v no \
#             -o "$output_file"
