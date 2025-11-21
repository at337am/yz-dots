#!/usr/bin/env bash


# 之后在重新写 bootstrap 脚本时，全部用统一用 ./ 执行不要用 source

# todo:

# ~/.ssh
# ~/.local/share/fonts
# ~/Pictures/PFP
# ~/Documents
# /data/restore




# ~/workspace/dev/yz-dots



# 执行 Migration 表示所有数据进行迁移
# 执行 bak 表示备份日常数据

PFP_PATH="$HOME/Pictures"

mkdir 

migration() {

    
}

target_dir="/data/bak/syncs"

mkdir -p "$target_dir"

sync_projects() {
    rsync -a --delete \
        "$HOME/Documents/" \
        "$target_dir/Documents/"

    rsync -a --delete \
        "$HOME/workspace/dev/" \
        "$target_dir/dev/"
}

pack_projects() {
    tar -cf "$HOME/Downloads/syncs_bak_$(date +"%y%m%d_%H%M%S").tar" -C /data/bak/ syncs
}



if [[ "$#" -eq 0 ]]; then
    sync_projects
elif [[ "$#" -eq 1 && "$1" == "bak" ]]; then
    pack_projects
else
    printf "参数错误\n" >&2
    printf "用法: syncs.sh [bak]\n" >&2
    exit 1
fi

printf "Done.\n"
