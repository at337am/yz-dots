#!/usr/bin/env bash

# 脚本概述：
    # 1. 提示用户确认是否继续安装操作。
    # 2. 清理旧的安装目录和数据目录。
    # 3. 下载指定版本（2.5）的 XHS-Downloader 源码。
    # 4. 解压并移动源码到目标安装目录 (/opt/soft/XHS-Downloader)。
    # 5. 在项目目录下创建并激活 Python 3.12 的虚拟环境。
    # 6. 使用 `uv` 工具生成依赖锁文件并同步安装依赖。
    # 7. 创建数据目录的符号链接 (/data/misc/xhs_dl)。

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



# ------------- 在项目目录下创建并激活虚拟环境 -------------

# 这一步会自动下载 Python 3.12 (如果没安装) 并创建 .venv 目录
uv venv --python 3.12

# 同步环境
uv sync

source .venv/bin/activate

uv pip compile requirements.txt -o uv.lock

uv pip sync uv.lock

ln -sf /opt/soft/XHS-Downloader/Download /data/misc/xhs_dl

printf "Done.\n"
