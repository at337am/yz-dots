#!/usr/bin/env bash

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to install xhs?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

# 先清理
rm -rf /opt/soft/XHS-Downloader
rm -rf /data/misc/xhs_dl



# ------------- 下载 python 3.12 -------------

yay -S --needed python312 --cleanafter



# ------------- 拉取项目 -------------
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# 拉取项目源码:
wget -O "$tmp_dir/2.5.tar.gz" https://github.com/JoeanAmier/XHS-Downloader/archive/refs/tags/2.5.tar.gz

tar -zxvf "$tmp_dir/2.5.tar.gz" -C "$tmp_dir"

mv "$tmp_dir/XHS-Downloader-2.5" "/opt/soft/XHS-Downloader"

# 进入项目所在目录, 创建并激活 3.12 的虚拟环境
cd /opt/soft/XHS-Downloader/

rm -f uv.lock

uv venv -p python3.12 .venv

source .venv/bin/activate

uv pip compile requirements.txt -o uv.lock

uv pip sync uv.lock

ln -sf /opt/soft/XHS-Downloader/Download /data/misc/xhs_dl

printf "Done.\n"
