#!/usr/bin/env bash

set -euo pipefail

# 下载对应的 python 3.12 版本
yay -S --needed python312 --cleanafter

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# 拉取项目源码:
wget -O "$tmp_dir/2.5.tar.gz" https://github.com/JoeanAmier/XHS-Downloader/archive/refs/tags/2.5.tar.gz

tar xvf "$tmp_dir/2.5.tar.gz" -C "$tmp_dir"

mv "$tmp_dir/XHS-Downloader-2.5" "/opt/soft/XHS-Downloader"

# 清理无用文件
rm -rf /opt/soft/XHS-Downloader/{.github,static,LICENSE,Dockerfile,README_EN.md,README.md} || true

# 进入项目所在目录, 创建并激活 3.12 的虚拟环境

cd /opt/soft/XHS-Downloader/

rm -f uv.lock

uv venv -p python3.12 .venv

source .venv/bin/activate

uv pip compile requirements.txt -o uv.lock

uv pip sync uv.lock

ln -sf /opt/soft/XHS-Downloader/Download /data/misc/xhs_dl

printf "Done.\n"
