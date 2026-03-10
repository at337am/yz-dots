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

# 遍历当前路径下, 所有「以 apk 为扩展名」的文件
for file in *.apk; do
    # 确保是普通文件 (跳过目录和特殊文件)
    [[ -f "$file" ]] || continue

    if adb install -r "$file"; then
        printf "OK -> %s\n" "$file"
        success=$((success + 1))
    else
        printf "ERR -> %s\n" "$file"
        fail=$((fail + 1))
    fi
    printf "%s\n" "-------------"
done

printf "%s\n" "--- Total ---"
printf "OK count: %d\n" "$success"
printf "ERR count: %d\n" "$fail"

notify-send "ADB" "all APKs have been installed."
"$WM_SCRIPTS/play_audio.sh" "complete.oga"
