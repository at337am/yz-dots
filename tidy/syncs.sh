#!/usr/bin/env bash

set -euo pipefail

# todo 支持给每个小的项目进行打包备份

# 需要同步的源路径
dev_path="$HOME/workspace/dev"
documents_path="$HOME/Documents"
fonts_path="$HOME/.local/share/fonts"
pfp_path="$HOME/Pictures/PFP"
restore_path="/data/misc/restore"

source_dirs=(
    "$dev_path"
    "$documents_path"
    "$fonts_path"
    "$pfp_path"
    "$restore_path"
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
mirroring() {
    for path in "${source_dirs[@]}"; do
        rsync -a --delete \
            "$path/" \
            "$TARGET_DIR/$(basename "$path")"
    done
}

# 迁移, 打包所有内容
pack_all() {
    local timestamp=$(date +"%y%m%d_%H%M%S")
    tar -cf "$HOME/Downloads/syncs_migration_${timestamp}.tar" -C /data/bak/ syncs
}

# 日常备份, 打包 proj 项目
pack_proj(){
    cd "$TARGET_DIR"
    mkdir -p ~/Downloads/proj_bak
    cp -a dev Documents ~/Downloads/proj_bak
    cd ~/Downloads
    tar -cf "proj_bak_$(date +"%y%m%d_%H%M%S").tar" proj_bak
    command rm -rf proj_bak
}

# 打包某个单独的内容
pack_one() {
    local name="$1"
    local timestamp=$(date +"%y%m%d_%H%M%S")
    tar -cf "$HOME/Downloads/${name}_bak_${timestamp}.tar" -C "$TARGET_DIR" "$name"
}

if [[ "$#" -eq 0 ]]; then
    mirroring
elif [[ "$#" -eq 1 && "$1" == "--proj" ]]; then
    mirroring
    pack_proj
elif [[ "$#" -eq 1 && "$1" == "--fonts" ]]; then
    mirroring
    pack_one "fonts"
elif [[ "$#" -eq 1 && "$1" == "--pfp" ]]; then
    mirroring
    pack_one "PFP"
elif [[ "$#" -eq 1 && "$1" == "--restore" ]]; then
    mirroring
    pack_one "restore"
elif [[ "$#" -eq 1 && "$1" == "--all" ]]; then
    mirroring
    pack_all
else
	printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s [-p | --mig]\n" "$(basename "$0")" >&2
    exit 1
fi

printf "Done.\n"
