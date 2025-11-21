#!/usr/bin/env bash

set -euo pipefail

# 需求: 
# 基础逻辑: 直接执行, 同步文档和项目到本地, 不做任何处理
# 加参数 bak: 执行一遍基础逻辑, 并打包起来到 ~/Downloads 目录
# 加参数 mig: 执行 基础逻辑 + 复杂逻辑, 并打包到 ~/Downloads 目录

# 需要同步的源路径
dev_path="$HOME/workspace/dev"
documents_path="$HOME/Documents"
fonts_path="$HOME/.local/share/fonts"
pfp_path="$HOME/Pictures/PFP"
restore_path="/data/misc/restore"
yz_dots_path="$HOME/workspace/dev/yz-dots"

source_dirs=(
    "$dev_path"
    "$documents_path"
    "$fonts_path"
    "$pfp_path"
    "$restore_path"
    "$yz_dots_path"
)

# 路径检查
for path in "${source_dirs[@]}"; do
    if [[ ! -d "$path" ]]; then
        printf "Error: $path is not a directory.\n" >&2
        exit 1
    fi
done

TARGET_DIR="/data/bak/syncs"
mkdir -p "$TARGET_DIR"

# -------------- 主要逻辑 --------------

# 只做同步
data_mirroring() {
    for path in "${source_dirs[@]}"; do
        rsync -a --delete \
            "$path/" \
            "$TARGET_DIR/$(basename "$path")"
    done
}

# 日常备份, 打包 proj 项目
syncs_proj(){
    cd "$TARGET_DIR"
    mkdir -p ~/Downloads/syncs_proj
    cp -a ./dev ./Documents ~/Downloads/syncs_proj
    cd ~/Downloads
    tar -cf syncs_proj_$(date +"%y%m%d_%H%M%S").tar syncs_proj
    command rm -rf syncs_proj
}

# syncs_proj(){
#     mkdir -p ~/Downloads/syncs_proj

#     cp -a \
#     "$TARGET_DIR/dev" \
#     "$TARGET_DIR/Documents" \
#     ~/Downloads/syncs_proj

#     tar -cf \
#     "~/Downloads/syncs_proj_$(date +"%y%m%d_%H%M%S").tar" \
#     -C ~/Downloads syncs_proj

#     command rm -rf ~/Downloads/syncs_proj
# }

# 迁移, 打包所有内容
syncs_migration() {
    tar -cf "$HOME/Downloads/syncs_migration_$(date +"%y%m%d_%H%M%S").tar" -C /data/bak/ syncs
}

if [[ "$#" -eq 0 ]]; then
    data_mirroring
elif [[ "$#" -eq 1 && "$1" == "-p" ]]; then
    syncs_proj
elif [[ "$#" -eq 1 && "$1" == "--mig" ]]; then
    syncs_migration
else
    printf "参数错误\n" >&2
    printf "用法: %s [-p|--mig]\n" "$(basename "$0")" >&2
    exit 1
fi

printf "Done.\n"
