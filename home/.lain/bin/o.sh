#!/usr/bin/env bash

set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <file>\n" "$(basename "$0")" >&2
    exit 1
fi

FILE="$1"

# 2. 提取后缀并转换为小写 (实现忽略大小写)
# ${FILE##*.} 获取最后一个 . 之后的内容
# ,, 是 Bash 4.0+ 的特性，将字符串转换为全小写
EXT="${FILE##*.}"
EXT="${EXT,,}"

# 如果文件名中没有点，或者就是纯点，处理一下异常（可选）
if [ "$FILE" = "$EXT" ]; then
    EXT=""
fi

# 3. 使用 case 语句匹配后缀并启动对应程序
# "$@" 允许你传递后续参数给程序 (虽然这里主要只用了 $FILE)
case "$EXT" in
    jpg|jpeg|png|gif|webp)
        qimgv "$FILE"
        ;;

    mp4|mkv|mov|m4v|webm|ts|avi)
        mpv "$FILE"
        ;;

    pdf)
        zathura "$FILE"
        ;;
    txt|md|conf|sh)
        nvim "$FILE"
        ;;

    # --- 未知后缀 ---
    *)
        echo "未定义的后缀: .$EXT"
        ;;
esac