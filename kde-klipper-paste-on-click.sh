#!/bin/bash
# Monitor for clipboard changes in KDE Klipper
dbus-monitor "sender='org.kde.klipper',interface='org.kde.klipper.klipper'" | \
while read -r line; do
    # When a line containing the signal is detected, run your code
    if echo "$line" | grep -q "clipboardHistoryUpdated"; then
        windowname=`kdotool getactivewindow getwindowname`
        if [[ "$windowname" == "Clipboard Popup" || "$windowname" == "plasmashell" ]]; then
            sleep 0.1 && ydotool key 42:1 110:1 110:0 42:0
        fi
    fi
done
