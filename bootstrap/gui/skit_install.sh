#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "just" &> /dev/null; then
    printf "Error: Missing dependency: just\n" >&2
    exit 1
fi

if [[ ! -d "/workspace/dev/skit" ]]; then
    printf "Error: skit directory does not exist!" >&2
    exit 1
fi

if [[ ! -d "/opt/soft" ]]; then
    printf "Error: /opt/soft does not exist.\n" >&2
    exit 1
fi

cd "/workspace/dev/skit"
just install-all

cd "/workspace/dev/skit/hello-server"
just pkg
mv hello-server /opt/soft

printf "Done.\n"

# git_clone() {
#     mkdir -p ~/Downloads/git_clone_tmp
#     cd ~/Downloads/git_clone_tmp
#     git clone git@github.com:at337am/notes.git
#     git clone git@github.com:at337am/yz-dots.git
#     git clone git@github.com:at337am/skit.git
#     git clone git@github.com:at337am/raindrop.git
# }
