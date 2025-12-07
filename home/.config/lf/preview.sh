#!/usr/bin/env bash

filepath="$1"
width="$2"
height="$3"
x="$4"
y="$5"

mimetype=$(file --mime-type -b "$filepath")

case "$mimetype" in
    image/*)
        echo "--- Image Metadata (ExifTool) ---"
        exiftool "$filepath"
        ;;

    video/* | audio/*)
        echo "--- Media Info (MediaInfo) ---"
        mediainfo "$filepath"
        ;;

    text/* | application/json | application/javascript)
        bat -n -P --color=always --terminal-width="$width" --wrap=character "$filepath"
        ;;

    *)
        echo "Mime-Type: $mimetype"
        echo "---------------------------------"
        file "$filepath"
        ;;
esac

exit 0
