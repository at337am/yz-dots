#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

selected_process=$(ps -u $USER -o pid,user,%cpu,%mem,comm --sort=-%cpu | sed '1d' | rofi -dmenu -i -p "processes" -theme ~/.config/rofi/themes/process_manager.rasi)

if [ -z "$selected_process" ]; then
    exit 0
fi

pid=$(echo "$selected_process" | awk '{print $1}')
comm=$(echo "$selected_process" | awk '{print $5}')

kill_term="Terminate (SIGTERM)"
kill_kill="Kill (SIGKILL)"
details="View Details"

options="$details\n$kill_term\n$kill_kill"

chosen_action=$(echo -e "$options" | rofi -dmenu -p "Action for $comm (PID: $pid)" -theme ~/.config/rofi/themes/process_manager.rasi)

case "$chosen_action" in
    "$kill_term")
        kill -15 "$pid"
        notify-send -a "processes" \
            "Sent SIGTERM to $comm"
        ;;
    "$kill_kill")
        kill -9 "$pid"
        notify-send -a "processes" \
            "Sent SIGKILL to $comm"        
        ;;
    "$details")
        kitty -e htop -p "$pid"
        ;;
esac

exit 0