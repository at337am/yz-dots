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
    mkdir -p ~/.config
    mkdir -p ~/.local/share/fonts
    mkdir -p ~/.local/share/restore
    mkdir -p ~/Pictures/PFP
    mkdir -p ~/Documents
    mkdir -p ~/Downloads/dl_tg

    sudo mkdir -p \
        /workspace/dev \
        /workspace/tmp \
        /data/bak \
        /data/avoid/pending \
        /data/hello/pending \
        /opt/soft

    sudo chown -R $(whoami):$(id -gn) \
        /workspace \
        /data \
        /opt/soft
}

migration() {
    rsync -a "$syncs_path/dev/" /workspace/dev/
    rsync -a "$syncs_path/Documents/" ~/Documents/
    rsync -a "$syncs_path/PFP/" ~/Pictures/PFP/
    rsync -a "$syncs_path/fonts/" ~/.local/share/fonts/
    rsync -a "$syncs_path/restore/" ~/.local/share/restore/
}

install_nekoray() {
    local nekoray_path="$HOME/.local/share/restore/nekoray.tar.gz"

	if [[ ! -f "$nekoray_path" ]]; then
		printf "Error:  %s does not exist.\n" "$nekoray_path" >&2
		exit 1
	fi

	rm -rf /opt/soft/nekoray

	tar -zxf "$nekoray_path" -C /opt/soft/

    # 赋予核心网络权限 (为了 TUN 模式)
    sudo setcap cap_net_admin,cap_net_bind_service+ep /opt/soft/nekoray/nekoray_core
    sudo setcap cap_net_admin,cap_net_bind_service+ep /opt/soft/nekoray/nekobox_core
}

configure_ssh_keys() {
    rm -rf ~/.ssh
    tar -xf "$ssh_path" -C ~/
}

home_symlinks() {
    rm -rf ~/workspace
    ln -sv /workspace ~/workspace

    rm -rf ~/tidy
    ln -sv /workspace/dev/yz-dots/tidy ~/tidy
}

create_path
migration
install_nekoray
configure_ssh_keys
home_symlinks
