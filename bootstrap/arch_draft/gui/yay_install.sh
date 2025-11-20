#!/usr/bin/env bash

set -euo pipefail

# yay 官方仓库: https://aur.archlinux.org/packages/yay

# vscode: https://wiki.archlinux.org/title/Visual_Studio_Code

yay -S \
    visual-studio-code-bin \
    qimgv-git

printf "Done.\n"
