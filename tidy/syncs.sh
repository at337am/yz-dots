#!/usr/bin/env bash

set -euo pipefail

# 定义颜色
RED='\033[0;31m'        # 红色
GREEN='\033[0;32m'      # 绿色
NC='\033[0m'            # 重置色

usage() {
    printf "Usage:\n"
    printf "  %s [flags]\n" "$(basename "$0")"
    printf "\nFlags:\n"
    printf "  -p, --pack            同步并打包所有内容 (准备迁移)\n"
    printf "  -s, --sync            仅同步 (默认)\n"
    printf "  -h, --help            Show this help message\n"
}

# 需要同步的源路径
documents_path="$HOME/Documents"
fonts_path="$HOME/.local/share/fonts"
pfp_path="$HOME/Pictures/PFP"
dev_path="/workspace/dev"
restore_path="$HOME/.local/share/restore"

source_dirs=(
    "$documents_path"
    "$fonts_path"
    "$pfp_path"
    "$dev_path"
    "$restore_path"
)

# 路径检查
for path in "${source_dirs[@]}"; do
    if [[ ! -d "$path" ]]; then
        printf "${RED}Error:${NC} %s is not a directory.\n" "$path" >&2
        exit 1
    fi
done

TARGET_DIR="/data/bak/syncs"
mkdir -p "$TARGET_DIR"

# 软件包列表文件存放位置
native_pkglist="$TARGET_DIR/pkglist-native.txt"
aur_pkglist="$TARGET_DIR/pkglist-aur.txt"

# -------------- 主要逻辑 --------------

# 只做同步
mirroring() {
    # 1. 同步所有目录内容
    for path in "${source_dirs[@]}"; do
        rsync -a --delete \
            "$path/" \
            "$TARGET_DIR/$(basename "$path")"
    done
    printf "Directories synced\n"

    # 2. 同步所有软件包列表
    pacman -Qqen > "$native_pkglist"
    pacman -Qqem > "$aur_pkglist"
    printf "Package lists synced\n"
}

# 为迁移做准备, 打包所有内容
pack_all() {
    local timestamp=$(date +"%y%m%d_%H%M%S")
    tar -cf "$HOME/Downloads/syncs_migration_${timestamp}.tar" -C /data/bak/ syncs
    printf "${GREEN}The migration has been packed into ~/Downloads${NC}\n"
}

# -------------- 程序主入口 --------------

# 参数个数不能大于 1
if [[ "$#" -gt 1 ]]; then
    printf "${RED}Error:${NC} Too many arguments.\n" >&2
    usage >&2
    exit 1
fi

# 如果 $1 为空 (无参数)，则赋值为 --sync
action="${1:---sync}"

case "$action" in
    -p|--pack)
        mirroring
        pack_all
        ;;
    -s|--sync)
        mirroring
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        printf "${RED}Error:${NC} Unknown flag %s\n" "$action" >&2
        usage >&2
        exit 1
        ;;
esac

printf "Done.\n"
