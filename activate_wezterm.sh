#!/bin/bash
APP_NAME="wezterm-gui"

last_active_window=$(cat /tmp/dotfiles_last_active_window.txt)
echo "last active window $last_active_window"

active_window_id=$(printf '0x%x\n' "$(xdotool getactivewindow)")
echo "Active window id $active_window_id"

TARGET_PID=$(pidof "$APP_NAME")
if [ -n "$TARGET_PID" ]; then
    echo "PID of $APP_NAME is: $TARGET_PID"
    window_info=$(wmctrl -l -p | awk -v pid="$TARGET_PID" '$3 == pid')

    if [ -n "$window_info" ]; then
        window_id=$(echo "$window_info" | awk '{print $1}')
        echo "Window ID of PID $TARGET_PID is: $window_id"

        if [ $((active_window_id)) != $((window_id)) ]; then
            echo "Activating wezterm"
            # xdotool windowactivate "$window_id" active_window_id_hex=$(printf '0x%x\n' "$(xdotool getactivewindow)")
            echo "$active_window_id" > /tmp/dotfiles_last_active_window.txt

            xdotool windowactivate --sync $window_id
        else
            echo "wezterm already active"
            xdotool windowminimize "$window_id"
            xdotool windowactivate "$last_active_window"
        fi
    else
        echo "Window not found for PID $TARGET_PID"
    fi

else
    echo "$APP_NAME is not running"
fi
