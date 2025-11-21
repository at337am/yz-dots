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
data_mirroring() {
    for path in "${source_dirs[@]}"; do
        rsync -a --delete \
            "$path/" \
            "$TARGET_DIR/$(basename "$path")"
    done
}

# 日常备份, 打包 proj 项目
pack_proj(){
    cd "$TARGET_DIR"
    mkdir -p ~/Downloads/syncs_proj
    cp -a ./dev ./Documents ~/Downloads/syncs_proj
    cd ~/Downloads
    tar -cf "syncs_proj_$(date +"%y%m%d_%H%M%S").tar" syncs_proj
    command rm -rf syncs_proj
}

# 迁移, 打包所有内容
pack_migration() {
    tar -cf "$HOME/Downloads/syncs_migration_$(date +"%y%m%d_%H%M%S").tar" -C /data/bak/ syncs
}

if [[ "$#" -eq 0 ]]; then
    data_mirroring
elif [[ "$#" -eq 1 && "$1" == "-p" ]]; then
    data_mirroring
    pack_proj
# elif [[ "$#" -eq 1 && "$1" == "--mig" ]]; then
#     data_mirroring
# elif [[ "$#" -eq 1 && "$1" == "--mig" ]]; then
#     data_mirroring
# elif [[ "$#" -eq 1 && "$1" == "--mig" ]]; then
#     data_mirroring
elif [[ "$#" -eq 1 && "$1" == "--mig" ]]; then
    data_mirroring
    pack_migration
else
	printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s [-p | --mig]\n" "$(basename "$0")" >&2
    exit 1
fi

printf "Done.\n"
