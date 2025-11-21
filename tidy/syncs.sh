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
    tar -cf "$HOME/Downloads/syncs_migration_$(date +"%y%m%d_%H%M%S").tar" -C /data/bak/ syncs
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

# 日常备份, 打包字体
pack_fonts() {
    cd "$TARGET_DIR"
    cp -a fonts ~/Downloads
    cd ~/Downloads
    tar -cf "fonts_bak_$(date +"%y%m%d_%H%M%S").tar" fonts
    command rm -rf fonts
}

# 日常备份, 打包照片
pack_pfp() {
    cd "$TARGET_DIR"
    cp -a PFP ~/Downloads
    cd ~/Downloads
    tar -cf "PFP_bak_$(date +"%y%m%d_%H%M%S").tar" PFP
    command rm -rf PFP
}

pack_restore() {
    cd "$TARGET_DIR"
    cp -a restore ~/Downloads
    cd ~/Downloads
    tar -cf "restore_bak_$(date +"%y%m%d_%H%M%S").tar" restore
    command rm -rf restore
}

if [[ "$#" -eq 0 ]]; then
    mirroring
elif [[ "$#" -eq 1 && "$1" == "--proj" ]]; then
    mirroring
    pack_proj
elif [[ "$#" -eq 1 && "$1" == "--fonts" ]]; then
    mirroring
    pack_fonts
elif [[ "$#" -eq 1 && "$1" == "--pfp" ]]; then
    mirroring
    pack_pfp
elif [[ "$#" -eq 1 && "$1" == "--restore" ]]; then
    mirroring
    pack_restore
elif [[ "$#" -eq 1 && "$1" == "--all" ]]; then
    mirroring
    pack_all
else
	printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s [-p | --mig]\n" "$(basename "$0")" >&2
    exit 1
fi

printf "Done.\n"
