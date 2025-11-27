#!/usr/bin/env bash

PIDFILE="/tmp/gpu-recording.pid"

if [ -f "$PIDFILE" ]; then
    # 如果正在录制，就杀掉进程（停止录制）
    kill -SIGINT $(cat "$PIDFILE")
    rm "$PIDFILE"
    notify-send "录屏已保存"
else
    # 开始录制
    # 注意：这里的 screen 可能需要改为你的显示器名称，如 eDP-1，用 hyprctl monitors 查看
    # 但通常 -w screen 在新版中能自动识别主屏
    gpu-screen-recorder -w screen -f 60 -a default_output -c mp4 -o "$HOME/Videos/Rec_$(date +%Y%m%d_%H%M%S).mp4" &
    echo $! > "$PIDFILE"
    notify-send "开始录屏..."
fi
