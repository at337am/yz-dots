#!/usr/bin/env bash

target_dir="/data/bak/syncs"

mkdir -p "$target_dir"

sync_docs() {
    rsync -a --delete \
        "$HOME/Documents/" \
        "$target_dir/docs/"
}

sync_projects() {
    rsync -a --delete \
        "$HOME/workspace/dev/" \
        "$target_dir/projects/"
}

bak_syncs() {
    tar -cf "$HOME/Downloads/syncs_bak_$(date +"%y%m%d_%H%M%S").tar" -C /data/bak/ syncs
}

if [[ "$#" -eq 0 ]]; then
    sync_docs
    sync_projects
elif [[ "$#" -eq 1 && "$1" == "bak" ]]; then
    bak_syncs
else
    printf "参数错误\n" >&2
    printf "用法: syncs.sh [bak]\n" >&2
    exit 1
fi

printf "Done.\n"
