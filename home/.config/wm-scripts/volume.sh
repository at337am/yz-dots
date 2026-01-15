#!/usr/bin/env bash

STEP=5
MIN_VOLUME=0
MAX_VOLUME=100
SINK="@DEFAULT_AUDIO_SINK@"

# 获取当前音量（0-100 整数）
get_volume() {
    wpctl get-volume $SINK | awk '{print $2 * 100}' | xargs printf "%.0f"
}

# 检查是否静音
is_muted() {
    wpctl get-volume $SINK | grep -q "[MUTED]"
}

# 将数值写入 wob 管道
update_wob() {
    local val=$1
    # 检查管道是否存在, 防止 wob 没启动导致脚本卡住
    if [[ -p "$WOB_SOCK" ]]; then
        # 超时保护, 如果 0.1 秒内没写进去 (说明没人读), 就自动放弃, 不卡死脚本
        timeout 0.1s sh -c "echo '$val' > '$WOB_SOCK'" 2>/dev/null
    fi
}

# --- 主逻辑 ---

case "$1" in
    up)
        current=$(get_volume)
        target=$((current + STEP))

        if [[ "$target" -gt "$MAX_VOLUME" ]]; then
            target=$MAX_VOLUME
        fi

        update_wob "$target"

        wpctl set-volume $SINK "${target}%"
        ;;
        
    down)
        current=$(get_volume)
        target=$((current - STEP))

        if [[ "$target" -lt "$MIN_VOLUME" ]]; then
            target=$MIN_VOLUME
        fi

        update_wob "$target"

        wpctl set-volume $SINK "${target}%"
        ;;
        
    mute)
        if is_muted; then
            # 如果当前已经静音了, 说明现在要打开声音了
            vol=$(get_volume)
            update_wob "$vol"
        else
            # 如果没有静音, 说明现在要静音了
            update_wob 0
        fi

        # 切换静音
        wpctl set-mute $SINK toggle
        ;;
esac
