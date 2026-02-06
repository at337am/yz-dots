#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "git" &> /dev/null; then
    printf "Error: Missing dependency: git\n" >&2
    exit 1
fi

git_clone() {
    mkdir -p ~/Downloads/tmp
    cd ~/Downloads/tmp
    git clone git@github.com:at337am/notes.git
    git clone git@github.com:at337am/yz-dots.git
    git clone git@github.com:at337am/skit.git
    git clone git@github.com:at337am/hello.git
    git clone git@github.com:at337am/raindrop.git
}

git_clone

printf "Done.\n"
