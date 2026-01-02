#!/usr/bin/env bash

# --------------- 开始安装常用的软件 ---------------
# yay 官方仓库: https://aur.archlinux.org/packages/yay
# vscode: https://wiki.archlinux.org/title/Visual_Studio_Code

set -euo pipefail

# 依赖检查
if ! command -v "yay" &> /dev/null; then
    printf "Error: Missing dependency: yay\n" >&2
    exit 1
fi

yay -S --needed --noconfirm \
    unimatrix-git \
    terminal-rain-lightning \
    qimgv-git \
    localsend-bin \
    ungoogled-chromium-bin \
    gpu-screen-recorder \
    visual-studio-code-bin

printf "Done.\n"
