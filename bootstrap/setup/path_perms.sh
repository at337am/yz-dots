#!/usr/bin/env bash

# 设置相关文件权限

set -euo pipefail

zsh() {
    chmod 600 ~/.zshrc
    chmod 600 ~/.zprofile
    chmod 600 ~/.p10k.zsh
}

# ------------- 如果脚本只接收到一个参数, 并且匹配 -------------

if [[ "$#" -eq 1 && "$1" == "zsh" ]]; then
    zsh
    exit 0
fi

chmod 600 ~/.gitconfig

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

zsh
