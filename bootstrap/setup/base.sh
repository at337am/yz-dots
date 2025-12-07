#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "rsync" &> /dev/null; then
    printf "Error: Missing dependency: rsync\n" >&2
    exit 1
fi

# ---------------- 检查所需文件 START ----------------
syncs_path="$HOME/syncs"
ssh_path="$HOME/ssh.tar"

if [[ ! -d "$syncs_path" ]]; then
    printf "Error: %s does not exist.\n" "$syncs_path" >&2
    exit 1
fi

if [[ ! -f "$ssh_path" ]]; then
    printf "Error: %s does not exist.\n" "$ssh_path" >&2
    exit 1
fi
# ---------------- 检查所需文件 END ----------------

create_path() {
    sudo mkdir -p \
        /workspace/dev \
        /workspace/tmp \
        /data/bak \
        /data/hello \
        /data/misc/tgboom \
        /opt/soft \
        /opt/venvs

    sudo chown -R $(whoami):$(id -gn) \
        /workspace \
        /data \
        /opt/soft \
        /opt/venvs
}

migration() {
    mkdir -p ~/Documents
    mkdir -p ~/Pictures
    mkdir -p ~/.config
    mkdir -p ~/.local/share

    rsync -a "$syncs_path/dev/" /workspace/
    rsync -a "$syncs_path/Documents/" ~/Documents/
    rsync -a "$syncs_path/PFP/" ~/Pictures/PFP/
    rsync -a "$syncs_path/fonts/" ~/.local/share/fonts/
    rsync -a "$syncs_path/restore/" /data/misc/restore/
}

configure_ssh_keys() {
    rm -rf ~/.ssh
    tar -xf "$ssh_path/ssh.tar" -C ~/
}

home_symlinks() {
    ln -sv /workspace ~/workspace
    ln -sv /workspace/dev/yz-dots/tidy ~/tidy
}

create_path
migration
configure_ssh_keys
home_symlinks
