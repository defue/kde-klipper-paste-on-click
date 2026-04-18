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
    if echo "$line" | grep -q "clipboardHistoryUpdated"; then
        windowname=`kdotool getactivewindow getwindowname`
        if [ "$VERBOSE" = true ]; then
            echo "[$(date +'%H:%M:%S')] clipboardHistoryUpdated event from \"$windowname\" window"
        fi
        if [[ "$windowname" == "Clipboard Popup" || "$windowname" == "plasmashell" ]]; then
            if [ "$VERBOSE" = true ]; then
                echo "[$(date +'%H:%M:%S')] trigger the paste command"
            fi
            # wait for the klipper popup window to disappear
            while [[ "$windowname" == "Clipboard Popup" || "$windowname" == "plasmashell" ]]
            do
                sleep 0.1
                windowname=`kdotool getactivewindow getwindowname`
            done
            # emulate SHIFT + INSERT keys press
            ydotool key 42:1 110:1 110:0 42:0
        fi
    fi
done
