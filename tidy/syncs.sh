#!/usr/bin/env bash

set -euo pipefail

# 需要同步的源路径
documents_path="$HOME/Documents"
fonts_path="$HOME/.local/share/fonts"
pfp_path="$HOME/Pictures/PFP"
dev_path="/workspace/dev"
restore_path="/data/misc/restore"

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
        printf "Error: %s is not a directory.\n" "$path" >&2
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

# 为迁移做准备, 打包所有内容
pack_all() {
    local timestamp=$(date +"%y%m%d_%H%M%S")
    tar -cf "$HOME/Downloads/syncs_migration_${timestamp}.tar" -C /data/bak/ syncs
    printf "The migration has been packed into ~/Downloads.\n"
}

# 日常备份, 打包 proj 项目
pack_proj(){
    cd "$TARGET_DIR"
    mkdir -p ~/Downloads/proj_bak
    cp -a dev Documents ~/Downloads/proj_bak
    cd ~/Downloads
    tar -cf "proj_bak_$(date +"%y%m%d_%H%M%S").tar" proj_bak
    command rm -rf proj_bak
    printf "proj packed and ready in ~/Downloads.\n"
}

# 打包某个单独的内容
pack_one() {
    local name="$1"
    local timestamp=$(date +"%y%m%d_%H%M%S")
    tar -cf "$HOME/Downloads/${name}_bak_${timestamp}.tar" -C "$TARGET_DIR" "$name"
    printf "%s packed and ready in ~/Downloads.\n" "$name"
}

usage() {
    printf "Usage: %s [OPTION]\n\nOptions:\n" "$(basename "$0")" >&2

    printf "  proj          打包 dev 和 Documents\n" >&2
    printf "  all           打包所有内容 (迁移)\n" >&2
    printf "  fonts         打包 fonts\n" >&2
    printf "  PFP           打包 PFP\n" >&2
    printf "  restore       打包 restore\n" >&2
}

if [[ "$#" -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
    usage
    exit 0
fi

if [[ "$#" -eq 0 ]]; then
    mirroring
elif [[ "$#" -eq 1 && "$1" == "proj" ]]; then
    mirroring
    pack_proj
elif [[ "$#" -eq 1 && "$1" =~ ^(fonts|PFP|restore)$ ]]; then
    mirroring
    pack_one "$1"
elif [[ "$#" -eq 1 && "$1" == "all" ]]; then
    mirroring
    pack_all
else
    printf "Error: Invalid arguments.\n" >&2
    usage
    exit 1
fi

printf "Done.\n"
