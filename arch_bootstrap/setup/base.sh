#!/usr/bin/env bash

set -euo pipefail

syncs_path="$HOME/syncs"
ssh_path="$HOME/ssh.tar"

# todo 这里检查所需文件是否存在, 比如 ssh

# 安装所需依赖
sudo -E pacman -S --needed rsync

system_init() {
    # todo: 设置硬件时钟为 UTC
    # sudo timedatectl set-local-rtc '0'

    # 设置免密关机
    echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee -a /etc/sudoers

    # 设置 sudo 过期时间为 60 分钟
    echo 'Defaults    timestamp_timeout=60' | sudo tee -a /etc/sudoers
    echo 'Defaults    !tty_tickets' | sudo tee -a /etc/sudoers
}

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

    ln -s /workspace ~/workspace
}

migration() {
    mkdir -p ~/Documents
    mkdir -p ~/Pictures
    mkdir -p ~/.config
    mkdir -p ~/.local/share

    rsync -a "$syncs_path/dev/" ~/workspace/
    rsync -a "$syncs_path/Documents/" ~/Documents/
    rsync -a "$syncs_path/PFP/" ~/Pictures/PFP/
    rsync -a "$syncs_path/fonts/" ~/.local/share/fonts/
    rsync -a "$syncs_path/restore/" /data/misc/restore/
}

configure_ssh_keys() {
    rm -rf ~/.ssh
    tar -xf "$ssh_path/ssh.tar" -C ~/
}

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to run this script?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

system_init
create_path
migration
configure_ssh_keys
