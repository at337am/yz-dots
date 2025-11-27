#!/usr/bin/env bash

STEP=5
MIN_VOLUME=0
MAX_VOLUME=100

# 默认音频输出设备
SINK="@DEFAULT_AUDIO_SINK@"

# --- 脚本主逻辑 ---

# 函数：获取当前音量（0-100之间的整数）
get_volume() {
    # wpctl get-volume 输出 "Volume: 0.80" 这样的格式
    # 我们用 awk 提取数字部分并乘以100，然后用 printf 转为整数
    wpctl get-volume $SINK | awk '{print $2 * 100}' | xargs printf "%.0f"
}

# 函数：检查是否静音
is_muted() {
    # 如果输出中包含 [MUTED]，则返回0 (表示true)
    wpctl get-volume $SINK | grep -q "[MUTED]"
}

# 根据传入的第一个参数（up, down, mute）执行不同操作
case "$1" in
    up)
        current=$(get_volume)

        target=$((current + STEP))

        if [ "$target" -gt "$MAX_VOLUME" ]; then
            target=$MAX_VOLUME
        fi

        # 提前通知, 这样子动画更顺畅
        notify-send -a "volume" \
                    -u low \
                    -h string:x-dunst-stack-tag:volume_notif \
                    "😪   ${target}%"

        wpctl set-volume $SINK "${target}%"
        ;;
    down)
        current=$(get_volume)

        target=$((current - STEP))

        if [ "$target" -lt "$MIN_VOLUME" ]; then
            target=$MIN_VOLUME
        fi

        # 提前通知, 这样子动画更顺畅
        notify-send -a "volume" \
                    -u low \
                    -h string:x-dunst-stack-tag:volume_notif \
                    "😪   ${target}%"

        wpctl set-volume $SINK "${target}%"
        ;;
    mute)
        # 切换静音
        wpctl set-mute $SINK toggle

        # 检查切换后的状态并发送通知
        if is_muted; then
            # 设置通知的应用程序名称为 volume
            # x-dunst-stack-tag 用来标记通知分组
            notify-send -a "volume" \
                        -u low \
                        -h string:x-dunst-stack-tag:volume_notif \
                        "🙉   Muted"
        else
            notify-send -a "volume" \
                        -u low \
                        -h string:x-dunst-stack-tag:volume_notif \
                        "Unmute"
        fi
        ;;
esac
