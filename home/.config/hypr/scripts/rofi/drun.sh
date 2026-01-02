#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# 只匹配 name 和 keywords
rofi -show drun -drun-match-fields name,keywords -theme ~/.config/rofi/themes/drun.rasi
