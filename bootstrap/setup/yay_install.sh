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
install_yay() {
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
    cd "$tmp_dir/yay"
    makepkg -si
}

if ! command -v "yay" &> /dev/null; then
    install_yay
fi

# --------------- 开始安装常用的软件 ---------------
# yay 官方仓库: https://aur.archlinux.org/packages/yay
# vscode: https://wiki.archlinux.org/title/Visual_Studio_Code

yay -S --needed \
    visual-studio-code-bin \
    qimgv-git \
    localsend-bin \
    ungoogled-chromium-bin \
    gpu-screen-recorder
