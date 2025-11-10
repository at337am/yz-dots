#!/usr/bin/env bash

filepath="$1"
width="$2"
mimetype=$(file --mime-type -b "$filepath")

case "$mimetype" in

    text/* | application/json | application/javascript)
        bat --color=always --paging=never --style=plain --terminal-width="$width" "$filepath"
        ;;

    *)
        echo "Mime-Type: $mimetype"
        echo "---------------------------------"
        file "$filepath"
        ;;
esac

exit 0
