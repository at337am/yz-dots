#!/usr/bin/env bash

set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <script_name>\n" "$(basename "$0")" >&2
    exit 1
fi

template_path="$HOME/.local/share/shnew/example.sh"
output_path="$1"

# 检查模板文件是否存在
if [[ ! -f "$template_path" ]]; then
    printf "Error: %s does not exist.\n" "$IMG_PATH" >&2
    exit 1
fi

# 拷贝模板文件
cp -a "$template_path" "$output_path"

printf "Created -> %s\n" "$output_path"
