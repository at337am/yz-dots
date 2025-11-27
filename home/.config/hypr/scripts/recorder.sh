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

# 检查参数, 必须有一个参数, 且必须是 full 或 region
if [[ "$#" -ne 1 ]] || ([[ "$1" != "full" && "$1" != "region" ]]); then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <region|full>\n" "$(basename "$0")" >&2
    exit 1
fi

trap 'rm -f "$status_file"; refresh_waybar' EXIT

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

# 检查是否在正在选择区域, 如果是, 则杀死再退出 (杀死后上一个进程也会触发取消通知)
if pgrep -x slurp > /dev/null; then
    pkill -x slurp
    exit 0
fi

# 依赖检查
dependencies=("gpu-screen-recorder" "slurp" "notify-send")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

output_file="$HOME/Videos/recorder_$(date +"%y%m%d_%H%M%S").mkv"
mkdir -p "$HOME/Videos"

# 区域录制
if [[ "$1" == "region" ]]; then
    if ! GEOMETRY=$(slurp -f '%wx%h+%x+%y'); then
        notify "REC Canc."
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

fi

# 注意: 脚本大概率是没有 bug 的, 如果有的话, 就把 区域截图 的逻辑删掉吧, 脑子乱乱的, 重构一下
