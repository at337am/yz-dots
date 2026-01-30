#!/usr/bin/env bash

set -euo pipefail

# 源文件路径
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
src="$script_dir/static/userChrome.css"

# Firefox 配置目录
FIREFOX_DIR="$HOME/.mozilla/firefox"

# 查找默认 profile 目录（以 .default-release 结尾的）
PROFILE_DIR=$(find "$FIREFOX_DIR" -maxdepth 1 -type d -name "*.default-release" | head -n 1)

# 检查是否找到
if [[ -z "$PROFILE_DIR" ]]; then
    printf "未找到 firefox 的 default-release 目录\n"
    exit 1
fi

mkdir -p "$PROFILE_DIR/chrome"

# 同步文件
rsync -a "$src" "$PROFILE_DIR/chrome/"

printf "Done.\n"
