# kde-klipper-paste-on-click
The goal of this repository is to add "paste on click" functionality to KDE plasma 6 Klipper on Wayland.

### How it works
The script listens to dbus klipper clipboardHistoryUpdated event and fires the paste command via ydotool if the event comes from "Clipboard Popup" or "plasmashell" windows. Tested on Debian 13.

### Known issues
- The script doesn't work when you click on the first item in the history, because it is already in the clipboard and the clipboardHistoryUpdated event is not fired by KDE.

### Installation
#### 1. Install [kdootool](https://github.com/jinliu/kdotool) from your distro repository or:
  * download the archive from the [kdotool github releases](https://github.com/jinliu/kdotool/releases) and extract it
  * make the binary file executable: `chmod +x kdotool`
  * move it to the `usr/bin` directory: `sudo mv kdotool /usr/bin/`
#### 2. Install [ydotool](https://github.com/ReimuNotMoe/ydotool) from your distro repository or:
  * download the archive from the [ydotool github releases](https://github.com/ReimuNotMoe/ydotool/releases) and extract it
  * make the ydotool and ydotoold files executable: `chmod +x ydotool*`
  * move them to the `usr/bin` directory: `sudo mv ydotool* /usr/bin/`
#### 3. Create systemd service for ydotool:
* Create the ydotool service config file:
```
sudo nano /etc/systemd/system/ydotoold.service
```
* Paste the following:
> replace 1000 in the code below with your uid, if it differs. You can get your uid by issuing the `id` command in the terminal
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
* Enable and start the service
```
sudo systemctl --system daemon-reload
sudo systemctl enable ydotoold
sudo systemctl start ydotoold
```
#### 4. Install the kde-klipper-paste-on-click script
* download the script from this repository
* make it executable: `chmod +x kde-klipper-paste-on-click.sh`
* create a systemd service to start it automatically:
  * `mkdir -p ~/.config/systemd/user`
  * `kate ~/.config/systemd/user/klipper-paste.service`

Paste the following:
> replace `/home/username/kde-klipper-paste-on-click.sh` with the actual location of the script
```
[Unit]
Description=Klipper Paste On Click
After=graphical-session.target

[Service]
ExecStart=/home/username/kde-klipper-paste-on-click.sh
Restart=always

[Install]
WantedBy=default.target
```
Enable and start the service
```
systemctl --user daemon-reload
systemctl --user enable klipper-paste.service
systemctl --user start klipper-paste.service
```
