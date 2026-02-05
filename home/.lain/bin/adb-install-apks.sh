#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途: 将当前路径下的所有 APK 文件安装到 Android 设备
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

set -euo pipefail

# 依赖检查
dependencies=("adb" "paplay")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

success=0
fail=0

# 遍历当前目录下所有 .apk 后缀的文件
for apk in *.apk
do
    # 检查是否存在文件
    [[ ! -f "$apk" ]] && continue

    if adb install -r "$apk"; then
        printf "OK -> %s\n" "$apk"
        success=$((success + 1))
    else
        printf "ERR -> %s\n" "$apk"
        fail=$((fail + 1))
    fi
    printf "%s\n" "-------------"
done

printf "%s\n" "--- Total ---"
printf "OK count: %d\n" "$success"
printf "ERR count: %d\n" "$fail"

notify-send "ADB" "all APKs have been installed."
"$WM_SCRIPTS/play_audio.sh" "complete.oga"
