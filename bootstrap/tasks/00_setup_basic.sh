#!/usr/bin/env bash

set -euo pipefail

check_file_exists() {
    echo "开始校验所需文件..."

    files=(
        "fonts.tar.gz"
        "nekoray.tar.gz"
        "ssh.tar"
    )

    files_dir="$HOME/pkgs"

    for file in "${files[@]}"; do
        if [[ ! -f "$files_dir/$file" ]]; then
            echo "Error: 所需文件不存在: $files_dir/$file"
            return 1
        fi
    done

    echo "所需文件校验完成"
}

setup_basic() {
    if [[ -d "/opt/soft" ]]; then
        echo "跳过: setup_basic()"
        return 0
    fi

    echo "开始基础设置..."

    echo "关闭防火墙..."
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld

    echo "设置硬件时钟为 UTC..."
    sudo timedatectl set-local-rtc '0'

    echo "设置 sudo 过期时间为 60 分钟..."
    echo 'Defaults    timestamp_timeout=60' | sudo tee -a /etc/sudoers
    echo 'Defaults    !tty_tickets' | sudo tee -a /etc/sudoers

    echo "设置免密关机..."
    echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee -a /etc/sudoers

    echo "创建相关目录结构..."

    mkdir -p ~/.config
    mkdir -p ~/.local/share

    sudo mkdir -p /workspace/dev /workspace/tmp
    sudo chown -R $(whoami):$(id -gn) /workspace
    ln -s /workspace ~/workspace

    sudo mkdir -p /data/bak/restore /data/hello /data/misc/tgboom
    sudo chown -R $(whoami):$(id -gn) /data

    sudo mkdir -p /opt/soft /opt/venvs
    sudo chown -R $(whoami):$(id -gn) /opt/soft /opt/venvs

    echo "基础设置完成"
}

unpack_file_to_path() {
    if [[ -d "/opt/soft/nekoray" ]]; then
        echo "跳过: unpack_file_to_path()"
        return 0
    fi

    echo "解压所需文件到指定位置..."

    tar -zxf "$files_dir/fonts.tar.gz" -C ~/.local/share/
    echo "fonts 已到位"

    command rm -rf ~/.ssh
    tar -zxf "$files_dir/ssh.tar" -C ~/
    echo "ssh 已到位"

    tar -zxf "$files_dir/nekoray.tar.gz" -C /opt/soft/
    echo "nekoray 已到位"

    echo "解压完成, 所有文件已到位"
}

check_file_exists
setup_basic
unpack_file_to_path
