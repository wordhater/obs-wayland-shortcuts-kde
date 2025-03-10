#!/bin/bash

# Built for KDE Plasma 6.X.X

echo Starting Installer for OBS Wayland Shortcuts
DE="$XDG_CURRENT_DESKTOP"

# THIS MUST BE A NEW EMPTY FOLDER, DO NOT SET TO ~ OR / OR ANY OTHER FOLDER WITH ITEMS IN IT

echo "Where do you want to install the files required for the script to run. Note: please enter full path from root (leave blank for default folder ~/.local/share/obs-wayland-shortcuts): "
read userinstallfolder

if [ -n "$userinstallfolder" ]; then
    if [ ${userinstallfolder:0:1} == "/" ] || [ $@ == '-f' ]; then
        INSTALLFOLDER=$userinstallfolder
    else
        echo Incomplete path entered, pass -f when running the script to force custom path
        exit 1
    fi
else
    echo Default installation location used
    INSTALLFOLDER=~/.local/share/obs-wayland-shortcuts
fi

echo Installing to: $INSTALLFOLDER

if [ $DE == "KDE" ] || [ $@ == '-f' ]; then
    echo Installing For Plasma
    # Move files into fixed locations
    if [ -d "$INSTALLFOLDER" ]; then
        rm $INSTALLFOLDER/main.py
        rm $INSTALLFOLDER/config.json
    else
        mkdir $INSTALLFOLDER
    fi
    cp src/main.py $INSTALLFOLDER/main.py
    # Generate Config
    echo Config Generation
    echo -------
    echo OBS Websockets has to be enabled method varies from device to device but the settings are usually on the top toolbar under tools
    echo Step 1: Enable the websockets server
    echo Step 2: Click generate password or type your own 
    echo Step 3: Click on show connect info for connection details
    echo
    echo Is OBS running on the same computer as this script? Y/N : 
    read hostmode
    echo Click "Show Connect Info"
    if [ $hostmode == "Y" ] || [ $hostmode == "y" ]; then
        host=localhost
    else
        echo Enter The server IP:
        read host
    fi
    echo Enter the Server Port:
    read port
    echo Enter the Server Password: 
    read password
    echo "If you wish to run the script in a custom virtual environment (venv), enter full path to the venv folder (Leave blank to use default location): "
    read venv_path
    if [[ -z "${venv_path}" ]]; then
        python3 -m venv "${INSTALLFOLDER}/venv"
        VENV_COMMAND="${INSTALLFOLDER}/venv/bin/activate &&"
    else
        if [ -f "${venv_path}/bin/activate" ]; then
            VENV_COMMAND=". ${venv_path}/bin/activate &&"
        else
            echo Creating virtualenv in selected location
            python3 -m venv $VENV_COMMAND
            VENV_COMMAND=". ${venv_path}/bin/activate &&"
        fi
    fi
    source "${venv_path}/bin/activate"
    pip install obsws-python
    timeout=3
    rm config.json
    cat >config.json <<EOL
{
    "host": "${host}",
    "port": ${port},
    "password": "${password}",
    "timeout": ${timeout}
}    
EOL
    cp config.json $INSTALLFOLDER/config.json

    # Generate .kksrc file for import into kde settings app
    HOME=~
    rm autoconfig.kksrc
    cat >autoconfig.kksrc <<EOL
[Custom Commands][obs.shortcuts.desktop.0]
Exec=${VENV_COMMAND} python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" toggle_replay_buffer
Name=OBS -- Toggle Replay Buffer

[Custom Commands][obs.shortcuts.desktop.1]
Exec=${VENV_COMMAND} python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" save_replay_buffer
Name=OBS -- Save Replay Buffer

[Custom Commands][obs.shortcuts.desktop.2]
Exec=${VENV_COMMAND} python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" start_recording
Name=OBS -- Start Recording

[Custom Commands][obs.shortcuts.desktop.3]
Exec=${VENV_COMMAND} python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" stop_recording
Name=OBS -- Stop Recording

[Custom Commands][obs.shortcuts.desktop.4]
Exec=${VENV_COMMAND} python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" toggle_virtualcam
Name=OBS -- Toggle Virtual Camera

[Custom Commands][obs.shortcuts.desktop.5]
Exec=${VENV_COMMAND} python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" start_virtualcam
Name=OBS -- Start Virtual Camera

[Custom Commands][obs.shortcuts.desktop.6]
Exec=${VENV_COMMAND} python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" stop_virtualcam
Name=OBS -- Stop Virtual Camera

EOL
    echo autoconfig.kkrc generated
    echo
    echo INSTRUCTIONS - The part I can\'t do automatically
    echo A settings menu will appear after you hit return, in this menu at the top right there will be a button with the text import. Click it. A popup menu should appear, open the dropdown and select custom scheme then open file and navigate to the directory you cloned the repository into. Open autoconfig.kksrc in the file picker and click import.
    echo Apply the changes and set shortcuts to run the new entries
    kcmshell6 kcm_keys

else
    echo Not on supported Desktop Environment, Exiting
    echo Pass argument -f to force script to run, may cause problems
fi
