#!/usr/bin/env bash

COLOR=$(grim -g "$(slurp -p)" -t ppm - | magick - -format '%[hex:u]' info:-)

echo "#$COLOR" | wl-copy

# 发送通知
notify() {
    notify-send -a "visuals" \
                -u low \
                -h string:x-dunst-stack-tag:volume_notif \
                "$1"
}

notify "picked"
