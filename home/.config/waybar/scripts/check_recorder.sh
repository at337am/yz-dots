#!/usr/bin/env bash

status_file="/tmp/recorder_status"

if [[ -f "$status_file" ]]; then
    echo "🎀 REC"
fi
