#!/usr/bin/env bash

set -euo pipefail

# 依赖检查
if ! command -v "just" &> /dev/null; then
    printf "Error: Missing dependency: just\n" >&2
    exit 1
fi

# 需要检查的目录列表
dirs=(
    "/workspace/dev/skit"
    "/workspace/dev/raindrop"
    "/workspace/dev/hello"
    "/opt/soft"
)

# 循环检查目录
for dir in "${dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
        printf "Error: %s does not exist.\n" "$dir" >&2
        exit 1
    fi
done



# ------------ skit ------------
cd "/workspace/dev/skit"
just install-all



# ------------ raindrop ------------
cd "/workspace/dev/raindrop"
just install



# ------------ hello ------------
systemctl --user stop hello
systemctl --user disable hello

cd "/workspace/dev/hello"
just pack
rm -rf /opt/soft/hello
mv release /opt/soft/hello

systemctl --user daemon-reload
systemctl --user enable hello
systemctl --user start hello



printf "Done.\n"
