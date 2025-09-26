#!/usr/bin/env bash

set -euo pipefail

echo "Verifying required files..."

files=(
    "fonts.tar.gz"
    "nekoray.tar.gz"
    "ssh.tar"
    "PFP.tar"
)

files_dir="$HOME/pkgs"

for file in "${files[@]}"; do
    if [[ ! -f "$files_dir/$file" ]]; then
        echo "Error: Required file does not exist: $files_dir/$file"
        return 1
    fi
done

echo "Required files verification complete."

setup_basic() {
    if [[ -d "/opt/soft" ]]; then
        echo "Skipping: setup_basic()"
        return 0
    fi

    echo "Starting basic setup..."

    # 关闭防火墙
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld

    # 设置硬件时钟为 UTC
    sudo timedatectl set-local-rtc '0'

    # 设置 sudo 过期时间为 60 分钟
    echo 'Defaults    timestamp_timeout=60' | sudo tee -a /etc/sudoers
    echo 'Defaults    !tty_tickets' | sudo tee -a /etc/sudoers

    # 设置免密关机
    echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee -a /etc/sudoers

    # 创建相关目录结构
    mkdir -p ~/.config
    mkdir -p ~/.local/share
    mkdir -p ~/Pictures

    sudo mkdir -p /workspace/dev /workspace/tmp
    sudo chown -R $(whoami):$(id -gn) /workspace
    ln -s /workspace ~/workspace

    sudo mkdir -p /data/bak/restore /data/hello /data/misc/tgboom
    sudo chown -R $(whoami):$(id -gn) /data

    sudo mkdir -p /opt/soft /opt/venvs
    sudo chown -R $(whoami):$(id -gn) /opt/soft /opt/venvs

    echo "Basic setup complete."
}

unpack_file_to_path() {
    if [[ -d "/opt/soft/nekoray" ]]; then
        echo "Skipping: unpack_file_to_path()"
        return 0
    fi

    echo "Unpacking required files to specified location..."

    tar -zxf "$files_dir/fonts.tar.gz" -C ~/.local/share/

    command rm -rf ~/.ssh
    tar -xf "$files_dir/ssh.tar" -C ~/

    tar -xf "$files_dir/PFP.tar" -C ~/Pictures

    tar -zxf "$files_dir/nekoray.tar.gz" -C /opt/soft/

    echo "Unpacking complete, all files are in place."
}

setup_basic
unpack_file_to_path
