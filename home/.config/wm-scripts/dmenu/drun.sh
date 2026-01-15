#!/usr/bin/env bash

if pgrep -x fuzzel > /dev/null; then
    pkill -x fuzzel
    exit 0
fi

fuzzel
