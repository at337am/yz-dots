#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途：
# 该脚本用于批量安装当前目录下的 APK 文件到通过 ADB 连接的 Android 设备。
# 功能说明：
# 1. 自动遍历当前目录下所有以 .apk 结尾的文件。
# 2. 使用 adb 安装每个 APK（带覆盖安装 -r 选项）。
# 3. 对每个 APK 安装结果进行统计，输出成功和失败数量。
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

if ! command -v "adb" &> /dev/null; then
    printf "Error: 缺少依赖命令: adb\n" >&2
    exit 1
fi

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
