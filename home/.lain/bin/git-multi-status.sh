#!/usr/bin/env bash

# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-
# 脚本用途: 批量检查多个 Git 仓库的工作区状态
# -=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-

# 依赖检查
if ! command -v "git" &> /dev/null; then
    printf "Error: Missing dependency: git\n" >&2
    exit 1
fi

PROJECT_PATHS=(
    "$HOME/Documents/notes"
    "$HOME/Documents/memos"
    "/workspace/dev/yz-dots"
    "/workspace/dev/skit"
    "/workspace/dev/raindrop"
)

# 定义颜色
RED='\033[0;31m'        # 红色
GREEN='\033[0;32m'      # 绿色
BLUE='\033[0;34m'       # 蓝色
MAGENTA='\033[0;35m'    # 紫色
NC='\033[0m'            # 重置色

for dir in "${PROJECT_PATHS[@]}"; do
    printf "${BLUE}▪ Checking: %s${NC}\n" "$dir"
    # printf "${BLUE}▪ Checking: %s${NC}\n" "${dir##*/}"

    # 检查 .git 目录是否存在, 这是判断是否为 git 仓库的最可靠方法
    if [[ ! -d "$dir/.git" ]]; then
        printf "  ${RED}Error: Not a git repository or directory does not exist${NC}\n\n"
        continue
    fi

    (
        cd "$dir" || exit 1

        status=$(git status --short)

        if [[ -z "$status" ]]; then
            # 如果输出为空, 说明工作区是干净的
            printf "  ${GREEN}✔ Clean${NC}\n\n"
        else
            # 如果有输出, 说明有变更
            printf "  ${MAGENTA}Changes detected:${NC}\n"
            echo "$status" | sed 's/^/   /'
            printf "\n"
        fi
    )
done

printf "All checks complete.\n"
