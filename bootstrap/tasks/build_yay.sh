#!/usr/bin/env bash

# 此脚本要在 configuration.sh 之后执行, 因为 yay 是使用 go 拉取依赖和编译的

# wiki: https://wiki.archlinuxcn.org/wiki/Yay

set -euo pipefail

# 依赖检查
dependencies=("go" "git")
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        printf "Error: Missing dependency: %s\n" "$cmd" >&2
        exit 1
    fi
done

# 构建并安装 yay
build_yay() {
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay-bin"
    cd "$tmp_dir/yay-bin"
    makepkg -si --noconfirm
}

build_yay
