#!/usr/bin/env bash

target_dir="/data/bak/syncs"

mkdir -p "$target_dir"

sync_docs() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='*/.git' \
        --exclude='notes/.obsidian' \
        "$HOME/Documents/" \
        "$target_dir/docs/"
}

sync_projects() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='*/.git' \
        "$HOME/workspace/dev/" \
        "$target_dir/projects/"
}

sync_docs
sync_projects

printf "\nOK, Synchronization completed!\n"
