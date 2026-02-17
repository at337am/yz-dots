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

destination="/opt/soft/XHS-Downloader"
source_code="https://github.com/JoeanAmier/XHS-Downloader/archive/refs/tags/2.6.tar.gz"

# 先清理旧的项目
rm -rf "$destination"

# ------------- 拉取项目 -------------
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

wget -P "$tmp_dir" "$source_code"

tar -zxvf "$tmp_dir/2.6.tar.gz" -C "$tmp_dir"

mv "$tmp_dir/XHS-Downloader-2.6" "$destination"



# ------------- 在项目目录下创建并激活虚拟环境 -------------
cd "$destination"

rm -rf .git .github

# 同步环境
uv sync

# 最后软链接
rm -rf /data/dl_xhs
ln -sv "$destination/Volume/Download" /data/hello/dl_xhs

printf "Done.\n"

# 后续手动更改配置:
# 编辑 /opt/soft/XHS-Downloader/Volume/settings.json
# "image_format": "JPEG"
# "author_archive": true
# "write_mtime": true
