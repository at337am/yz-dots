#!/usr/bin/env bash

# 1. 定义变量
PROJECT_NAME=$1
TEMPLATE_DIR="$HOME/.config/shnew/templates"
TARGET_DIR="$(pwd)/$PROJECT_NAME"

# 2. 参数检查
if [ -z "$PROJECT_NAME" ]; then
    echo "错误: 请提供项目名称。"
    echo "用法: shnew.sh <project_name>"
    exit 1
fi

# 3. 检查模板目录是否存在
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "错误: 模板目录 $TEMPLATE_DIR 不存在。"
    echo "请先创建该目录并放入示例脚本。"
    exit 1
fi

# 4. 创建项目目录
if [ -d "$TARGET_DIR" ]; then
    echo "错误: 目录 $PROJECT_NAME 已存在。"
    exit 1
fi

echo "正在创建项目: $PROJECT_NAME ..."
mkdir -p "$TARGET_DIR"

# 5. 拷贝模板文件
# 使用 -r 递归拷贝，确保隐藏文件（如 .gitignore）也能拷过去
cp -r "$TEMPLATE_DIR"/. "$TARGET_DIR/"

# 6. 初始化 Git
cd "$TARGET_DIR" || exit
git init

# 7. (可选) 自动给所有 .sh 文件添加可执行权限
chmod +x *.sh 2>/dev/null

echo "完成！项目已初始化在: $TARGET_DIR"