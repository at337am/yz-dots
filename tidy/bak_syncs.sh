#!/usr/bin/env bash

target_dir="/data/bak/syncs"

mkdir -p "$target_dir"

bak_docs() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='*/.git' \
        --exclude='notes/.obsidian' \
        "$HOME/Documents/" \
        "$target_dir/docs/"
}

bak_projects() {
    rsync -avh \
        --delete \
        --delete-excluded \
        --exclude='*/.git' \
        "$HOME/workspace/dev/" \
        "$target_dir/projects/"
}

bak_docs
bak_projects

printf "Done.\n"
