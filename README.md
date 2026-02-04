# kde-klipper-paste-on-click
The goal of this script is to add paste on click functionality in KDE plasma 6 Klipper app.

### How it works
The script listens to dbus klipper clipboardHistoryUpdated event and fires the paste command via ydotool if the event came from "Clipboard Popup" or "plasmashell" windows. Tested on Debian 13.

### Known issues
- The script doesn't work when you click on the first item in the history, because clipboardHistoryUpdated event is not fired by KDE.

### Installation
1. Install [kdootool](https://github.com/jinliu/kdotool)
2. Install [ydotool](https://github.com/ReimuNotMoe/ydotool)
3. Create systemd service for ydotool:
- replace 1000 in the code below with your uid, if it differs. You can get your uid by issuing the `id` command in the terminal
- `sudo nano /etc/systemd/system/ydotoold.service`
```
[Unit]
Description=ydotool daemon
After=user@1000.service
Requires=user@1000.service

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/usr/bin/ydotoold -p /run/user/1000/.ydotool_socket -o 1000:1000

[Install]
WantedBy=multi-user.target
```
- Enable and start the service
```
sudo systemctl --system daemon-reload
sudo systemctl enable ydotoold
sudo systemctl start ydotoold
```
4. Download the script, make it executable and run