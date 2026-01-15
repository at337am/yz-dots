#!/usr/bin/env bash

audio_file="/usr/share/sounds/freedesktop/stereo/$1"

[[ -f "$audio_file" ]] && paplay "$audio_file" &
