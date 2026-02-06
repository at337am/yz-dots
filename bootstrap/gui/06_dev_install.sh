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

if [[ ! -d "/workspace/dev/raindrop" ]]; then
    printf "Error: raindrop directory does not exist!" >&2
    exit 1
fi

if [[ ! -d "/opt/soft" ]]; then
    printf "Error: /opt/soft does not exist.\n" >&2
    exit 1
fi



# ------------ skit ------------
cd "/workspace/dev/skit"
just install-all



# ------------ hello-server ------------
cd "/workspace/dev/skit/hello-server"
just pkg
rm -rf /opt/soft/hello-server
mv hello-server /opt/soft

# 将 hello.service 设置为自动启动, 并立刻启动
systemctl --user daemon-reload
systemctl --user enable --now hello



# ------------ raindrop ------------
cd "/workspace/dev/raindrop"
just install

printf "Done.\n"
