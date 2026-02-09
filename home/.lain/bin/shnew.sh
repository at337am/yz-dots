#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "git" &> /dev/null; then
    printf "Error: Missing dependency: git\n" >&2
    exit 1
fi

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <project_name>\n" "$(basename "$0")" >&2
    exit 1
fi

PROJECT_NAME="$1"
template_dir="$HOME/.local/share/shnew/templates"

# 检查模板目录是否存在
if [[ ! -d "$template_dir" ]]; then
    printf "Error: %s does not exist.\n" "$IMG_PATH" >&2
    exit 1
fi

# 创建项目目录
if [[ -d "$PROJECT_NAME" ]]; then
    echo "Error: 目录 $PROJECT_NAME 已存在"
    exit 1
fi

mkdir -p "$PROJECT_NAME"

# 拷贝模板文件
cp -a "$template_dir"/. "$PROJECT_NAME/"

# 6. 初始化 Git
cd "$PROJECT_NAME" || exit
git init

# 7. (可选) 自动给所有 .sh 文件添加可执行权限
chmod +x *.sh 2>/dev/null

echo "完成！项目已初始化在: $PROJECT_NAME"