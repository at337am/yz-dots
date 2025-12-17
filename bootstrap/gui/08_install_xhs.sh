#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
dependencies=("uv" "wget")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to install xhs?"; then
    printf "Operation cancelled.\n" >&2
    exit 1
fi

# 先清理
rm -rf /opt/soft/XHS-Downloader
# rm -rf /data/dl_xhs



# ------------- 拉取项目 -------------
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

wget -O "$tmp_dir/2.5.tar.gz" https://github.com/JoeanAmier/XHS-Downloader/archive/refs/tags/2.5.tar.gz

tar -zxvf "$tmp_dir/2.5.tar.gz" -C "$tmp_dir"

mv "$tmp_dir/XHS-Downloader-2.5" "/opt/soft/XHS-Downloader"



# ------------- 在项目目录下创建并激活虚拟环境 -------------
cd /opt/soft/XHS-Downloader

rm -rf .git .github

# 同步环境
uv sync

# rm -rf /data/dl_xhs
# ln -sv /opt/soft/XHS-Downloader/Download /data/dl_xhs

printf "Done.\n"
