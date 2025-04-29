# OBS Wayland Shortcuts

A python script which uses OBS-websockets to enable global shortcuts under wayland, through the use of the kde keyboard shortcuts menu.

NOTE: newer versions of KDE plasma may have some issues when importing the generated config, I will work on a fix when I get the time

## Requirements

tested on python 3.13 and fedora 41 KDE spin however *should* work on other python3 versions and other linux distributions

OBS websockets installed and enabled. These may be included in newer versions of OBS, check the upper toolbar menus the settings should be there if installed

## Installation

Run the following commands in a terminal to install

Note: this will create a folder in your home folder with the script and a virtual environment in it (no matter where you clone to). It needs to be there for the scripts to work consistently.


```bash
git clone https://github.com/wordhater/obs-wayland-shortcuts-kde
cd obs-wayland-shortcuts-kde
chmod +x install.sh
./install.sh
```

## TODO

- add gnome/other DE support
- expand available shortcuts
