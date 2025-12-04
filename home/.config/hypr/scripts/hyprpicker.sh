#!/usr/bin/env bash

if pgrep -x hyprpicker > /dev/null; then
    pkill -x hyprpicker
    exit 0
fi

# 屏幕拾色
hyprpicker --autocopy --format=hex
