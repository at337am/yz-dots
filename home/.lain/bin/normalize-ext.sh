#!/usr/bin/env bash

set -euo pipefail

# 遍历当前路径下，所有「有扩展名」的文件
for file in *.*; do
    # 确保是普通文件 (跳过目录和特殊文件)
    [[ -f "$file" ]] || continue

    filename="${file%.*}"
    ext="${file##*.}"

    # 后缀转换为小写
    ext_lower="${ext,,}"

    case "$ext_lower" in
        jpeg|jpe)
            new_ext="jpg"
            ;;
        *)
            # 如果没有匹配到特殊规则, 就直接使用小写后缀
            new_ext="$ext_lower"
            ;;
    esac

    new_file="${filename}.${new_ext}"

    # 如果新文件名和旧文件名不同, 才执行重命名
    if [[ "$file" != "$new_file" ]]; then
        # 检查目标文件是否已经存在, 防止覆盖
        if [[ -e "$new_file" ]]; then
            printf "Error: 无法将 '%s' 重命名为 '%s', 因为目标文件已存在\n" "$file" "$new_file" >&2
        else
            mv "$file" "$new_file"
            printf "rename: '%s' -> '%s'\n" "$file" "$new_file"
        fi
    fi
done

printf "Done.\n"
