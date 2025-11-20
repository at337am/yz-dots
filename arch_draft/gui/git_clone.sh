#!/usr/bin/env bash

set -euo pipefail

# 因为这里用到了 .ssh/config 的代理, 只能他妈的在 nekoray 启动后执行此脚本

git clone git@github.com:at337am/notes.git ~/Documents/notes

git clone git@github.com:at337am/yz-dots.git ~/workspace/dev/yz-dots

git clone git@github.com:at337am/skit.git ~/workspace/dev/skit

git clone git@github.com:at337am/raindrop.git ~/workspace/dev/raindrop

echo "Project cloning complete."

echo "Preparing to install skit..."

if [[ ! -d "$HOME/workspace/dev/skit" ]]; then
    echo "Error: skit directory does not exist!"
    exit 1
fi

(
    cd "$HOME/workspace/dev/skit" && \
    just install-all
)

printf "Done.\n"
