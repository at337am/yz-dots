#!/usr/bin/env bash

set -euo pipefail

TARGET_DIR="/opt/soft/hello-server"

if [[ ! -d "$TARGET_DIR" ]]; then
    printf "Error: hello server directory not found.\n" >&2
    exit 1
fi

# 如果进程已存在, 则退出
if pgrep -x "hello" > /dev/null; then
    printf "🫠 Hey, the hello server is already running. Bye!\n"
    exit 0
fi

cd "$TARGET_DIR" && mkdir -p runtime

nohup ./hello >> runtime/out.log 2>> runtime/err.log &

sleep 0.5

# 检查服务是否启动成功
if ! pgrep -x "hello" > /dev/null; then
    printf "Error: failed to start hello server\n" >&2
    exit 1
fi

printf "🦋 hello server started successfully!\n"

# todo: 这个只能先进入目录里面使用 ./ 执行, 需要改经 hello-server 业务逻辑
