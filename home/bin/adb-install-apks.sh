#!/usr/bin/env bash

if ! command -v adb &> /dev/null; then
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
