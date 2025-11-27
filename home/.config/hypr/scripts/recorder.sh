#!/usr/bin/env bash

output_dir="$HOME/Videos"
status_file="/tmp/recorder_status"

# 定义一个刷新 Waybar 的函数
refresh_waybar() {
    pkill -SIGRTMIN+8 waybar
}

trap 'rm -f "$status_file"; refresh_waybar' EXIT

usage() {
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <region|full>\n" "$(basename "$0")" >&2
}

# todo 需求, 直接在这里强行 验证参数是否正确
if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
fi

if pgrep -x slurp > /dev/null; then
    pkill -x slurp
    exit 0
fi

# 发送通知
notify() {
    notify-send -a "recorder" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

# 检查是否已经在运行
if pgrep -f "gpu-screen-recorder" > /dev/null; then
    # -2 相当于 Ctrl + C
    pkill -2 -f "gpu-screen-recorder"

    notify "STOP REC"

    # 这里可以不用这两个, 因为 exit 0 会自动触发 trap 来做这两件事, 但没关系
    rm -f "$status_file"
    refresh_waybar

    exit 0
fi

mkdir -p "$output_dir"
output_file="$output_dir/recorder_$(date +"%y%m%d_%H%M%S").mkv"

# 区域录制
if [[ "$1" == "region" ]]; then
    if ! GEOMETRY=$(slurp -f '%wx%h+%x+%y'); then
        notify "Cancel"
        exit 0
    fi

    notify "😎  REC"

    touch "$status_file"
    refresh_waybar

    # 混合音轨
    timeout -s 2 -k 10s 3600 gpu-screen-recorder \
                -w region \
                -region "$GEOMETRY" \
                -f 60 \
                -bm cbr \
                -q 15000 \
                -a "default_output|default_input" \
                -v no \
                -o "$output_file"

    # 只录制系统声音
    # timeout -s 2 -k 10s 3600 gpu-screen-recorder \
    #             -w region \
    #             -region "$GEOMETRY" \
    #             -f 60 \
    #             -bm cbr \
    #             -q 15000 \
    #             -a default_output \
    #             -v no \
    #             -o "$output_file"

# 全屏录制
elif [[ "$1" == "full" ]]; then
    notify "😎  REC"

    touch "$status_file"
    refresh_waybar

    # 混合音轨
    timeout -s 2 -k 10s 3600 gpu-screen-recorder \
                -w screen \
                -f 60 \
                -bm cbr \
                -q 15000 \
                -a "default_output|default_input" \
                -v no \
                -o "$output_file"

    # # 双音轨
    # timeout -s 2 -k 10s 3600 gpu-screen-recorder \
    #             -w screen \
    #             -f 60 \
    #             -bm cbr \
    #             -q 15000 \
    #             -a default_output -a default_input \
    #             -v no \
    #             -o "$output_file"

    # # 只录制系统声音
    # timeout -s 2 -k 10s 3600 gpu-screen-recorder \
    #             -w screen \
    #             -f 60 \
    #             -bm cbr \
    #             -q 15000 \
    #             -a default_output \
    #             -v no \
    #             -o "$output_file"

else
    usage
    exit 1
fi
