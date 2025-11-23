#!/usr/bin/env bash

set -euo pipefail

# yay - wiki: https://wiki.archlinuxcn.org/wiki/Yay

# 此脚本最好在 go_install.sh 之后执行, 因为 yay 需要使用 go 编译

install_yay() {
    tmp_dir=$(mktemp -d)
    trap 'command rm -rf "$tmp_dir"' EXIT

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
    xcursor-breeze

printf "Done.\n"
