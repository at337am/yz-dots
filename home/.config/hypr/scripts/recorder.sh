#!/usr/bin/env bash

output_dir="$HOME/Videos"
status_file="/tmp/recording_status"
trap 'rm -f "$status_file"' EXIT

usage() {
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <region|full>\n" "$(basename "$0")" >&2
}

if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
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

    rm -f "$status_file"

    notify "REC Stop"

    exit 0
fi

mkdir -p "$output_dir"
output_file="$output_dir/recorder_$(date +"%y%m%d_%H%M%S").mkv"

# 区域录制
if [[ "$1" == "region" ]]; then
    if ! GEOMETRY=$(slurp -f '%wx%h+%x+%y'); then
        notify "REC Canceled"
        exit 0
    fi

    notify "REC Start"

    touch "$status_file"

    gpu-screen-recorder \
                -w region \
                -region "$GEOMETRY" \
                -f 60 \
                -bm cbr \
                -q 15000 \
                -a "default_output|default_input" \
                -v no \
                -o "$output_file"
# 全屏录制
elif [[ "$1" == "full" ]]; then
    notify "REC Start"

    touch "$status_file"

    gpu-screen-recorder \
                -w screen \
                -f 60 \
                -bm cbr \
                -q 15000 \
                -a "default_output|default_input" \
                -v no \
                -o "$output_file"

else
    usage
    exit 1
fi
