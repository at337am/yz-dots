#!/usr/bin/env bash

kill_apps() {
    pkill -15   -x "nekoray"
    pkill -15   -x "nekobox_core"
    pkill -2    -f "gpu-screen-recorder"
    pkill -15   -x "Telegram"
}

# 不管怎样都要返回 true
kill_apps || true
