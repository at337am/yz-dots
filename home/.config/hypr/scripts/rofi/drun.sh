#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

rofi -show drun -drun-match-fields name -theme ~/.config/rofi/themes/drun.rasi
