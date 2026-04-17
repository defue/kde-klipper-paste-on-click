#!/bin/bash

VERBOSE=false
while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE=true
      shift # Move to the next argument
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Monitor for clipboard changes in KDE Klipper
dbus-monitor "sender='org.kde.klipper',interface='org.kde.klipper.klipper'" | \
while read -r line; do
    # When a line containing the signal is detected, run your code
    if echo "$line" | grep -q "clipboardHistoryUpdated"; then
        windowname=`kdotool getactivewindow getwindowname`
        if [ "$VERBOSE" = true ]; then
            echo "[$(date +'%H:%M:%S')] clipboardHistoryUpdated event from \"$windowname\" window"
        fi
        if [[ "$windowname" == "Clipboard Popup" || "$windowname" == "plasmashell" ]]; then
            if [ "$VERBOSE" = true ]; then
                echo "[$(date +'%H:%M:%S')] trigger the paste command"
            fi
            sleep 0.1 && ydotool key 42:1 110:1 110:0 42:0
        fi
    fi
done
