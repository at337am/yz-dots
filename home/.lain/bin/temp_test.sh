#!/usr/bin/env bash

set -euo pipefail

# --- 全局变量 ---
VERSION="1.0.0"
SCRIPT_NAME=$(basename "$0")

# --- 帮助信息 ---
usage() {
    cat <<EOF
用法: $SCRIPT_NAME [选项] <必填参数1> <必填参数2>

说明: 这是一个遵循最佳实践的 Shell 脚本模板。

选项:
  -h, --help            显示此帮助信息
  -v, --version         显示版本号
  -f, --file FILE       指定输入文件
  -o, --output DIR      指定输出目录 (默认: ./output)
  --verbose             启用详细日志

示例:
  $SCRIPT_NAME -f input.txt /tmp/data
EOF
}

# --- 版本信息 ---
version() {
    echo "$SCRIPT_NAME version $VERSION"
}

# --- 参数解析逻辑 ---
# 使用 GNU getopt 解析参数
# -o: 短参数 (冒号表示后跟参数值)
# -l: 长参数 (逗号分隔)
# --: 分隔符
ARGS=$(getopt -o hvf:o: \
    -l help,version,file:,output:,verbose \
    -n "$SCRIPT_NAME" -- "$@")

# 如果 getopt 执行失败（输入了未知参数），退出
if [ $? -ne 0 ]; then
    usage
    exit 1
fi

# 重新挂载解析后的参数到 $1, $2...
eval set -- "$ARGS"

# 设置默认值
FILE=""
OUTPUT_DIR="./output"
VERBOSE=false

# 循环处理参数
while true; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        -v | --version)
            version
            exit 0
            ;;
        -f | --file)
            FILE="$2"
            shift 2
            ;;
        -o | --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "内部错误!"
            exit 1
            ;;
    esac
done

# --- 参数个数逻辑限制 ---
# $# 现在代表排除掉 -f, --help 等选项后，剩余的“位置参数”个数
# 假设我们需要 1 个必填参数 (e.g., 目标路径)
if [ $# -lt 1 ]; then
    echo "错误: 缺少必填参数。"
    usage
    exit 1
fi

if [ $# -gt 2 ]; then
    echo "错误: 参数过多。"
    usage
    exit 1
fi

TARGET_PATH=$1

# --- 核心业务逻辑 ---
main() {
    echo "配置信息:"
    echo "  文件: $FILE"
    echo "  输出: $OUTPUT_DIR"
    echo "  详细模式: $VERBOSE"
    echo "  目标路径: $TARGET_PATH"

    if [ "$VERBOSE" = true ]; then
        echo "正在执行复杂操作..."
    fi
}

main
