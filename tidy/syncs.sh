#!/usr/bin/env bash


# 需求: 
# 基础逻辑: 直接执行, 同步文档和项目到本地, 不做任何处理
# 加参数 bak: 执行一遍基础逻辑, 并打包起来到 ~/Downloads 目录
# 加参数 mig: 执行 基础逻辑 + 复杂逻辑, 并打包到 ~/Downloads 目录

# todo:

# ~/Documents
# ~/workspace/dev

# ~/.local/share/fonts
# ~/Pictures/PFP
# /data/restore
# ~/workspace/dev/yz-dots



TARGET_DIR="/data/bak/syncs"

mkdir -p "$TARGET_DIR"

sync_dev() {
    rsync -a --delete \
        "$HOME/workspace/dev/" \
        "$TARGET_DIR/dev/"
}

sync_documents() {
    rsync -a --delete \
        "$HOME/Documents/" \
        "$TARGET_DIR/Documents/"
}

sync_fonts() {
    rsync -a --delete \
        "$HOME/.local/share/fonts/" \
        "$TARGET_DIR/fonts/"
}

sync_pfp() {
    rsync -a --delete \
        "$HOME/Pictures/PFP/" \
        "$TARGET_DIR/PFP/"
}

sync_restore() {
    rsync -a --delete \
        "/data/restore/" \
        "$TARGET_DIR/restore/"
}

sync_yz_dots() {
    rsync -a --delete \
        "$HOME/workspace/dev/yz-dots/" \
        "$TARGET_DIR/yz-dots/"
}

backup() {
    tar -cf "$HOME/Downloads/syncs_bak_$(date +"%y%m%d_%H%M%S").tar" -C /data/bak/ syncs
}


migration() {
    
}



if [[ "$#" -eq 0 ]]; then
    sync_dev
    sync_documents
elif [[ "$#" -eq 1 && "$1" == "bak" ]]; then
    backup
else
    printf "参数错误\n" >&2
    printf "用法: syncs.sh [bak]\n" >&2
    exit 1
fi

printf "Done.\n"
