# kde-klipper-paste-on-click
The goal of this script is to add paste on click functionality in KDE plasma 6 Klipper app.

### How it works
The script listens to dbus klipper clipboardHistoryUpdated event and fires paste through ydotool

### Known issues
- the script doesn't work when you click on the first item in the history, because clipboardHistoryUpdated event is not fired by KDE.

### Installation
1. Install [kdootool](https://github.com/jinliu/kdotool)
2. Install [ydotool](https://github.com/ReimuNotMoe/ydotool)
3. Create systemd service for ydotool
- replace 1000 in the code below with your uid, if it differs. You can get your uid by issuing the id command in terminal
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
systemctl --system daemon-reload
systemctl enable ydotoold
systemctl start ydotoold
```

3. Download the script, make it executable and run

Tested on Debian 13