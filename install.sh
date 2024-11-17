#!/bin/bash

# Built for KDE Plasma 6.X.X

echo Starting Installer for OBS Wayland Shortcuts
DE="$XDG_CURRENT_DESKTOP"

# THIS MUST BE A NEW EMPTY FOLDER, DO NOT SET TO ~ OR / OR ANY OTHER FOLDER WITH ITEMS IN IT
INSTALLFOLDER=~/.OBS_wayland_shortcuts



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
    pip install obsws_python
    # Generate Config
    echo Config Generation
    echo -------
    echo OBS Websockets has to be enabled method varies from device to device but the settings are usually on the top toolbar under tools
    echo Step 1: Enable the websockets server
    echo Step 2: Click generate password or type your own password
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
Exec=python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" toggle_replay_buffer
Name=OBS -- Toggle Replay Buffer

[Custom Commands][obs.shortcuts.desktop.1]
Exec=python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" save_replay_buffer
Name=OBS -- Save Replay Buffer

[Custom Commands][obs.shortcuts.desktop.2]
Exec=python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" start_recording
Name=OBS -- Start Recording

[Custom Commands][obs.shortcuts.desktop.3]
Exec=python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" stop_recording
Name=OBS -- Stop Recording

[Custom Commands][obs.shortcuts.desktop.4]
Exec=python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" toggle_virtualcam
Name=OBS -- Toggle Virtual Camera

[Custom Commands][obs.shortcuts.desktop.5]
Exec=python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" start_virtualcam
Name=OBS -- Start Virtual Camera

[Custom Commands][obs.shortcuts.desktop.6]
Exec=python "${INSTALLFOLDER}/main.py" "${INSTALLFOLDER}" stop_virtualcam
Name=OBS -- Stop Virtual Camera

EOL
    echo autoconfig.kkrc generated
    echo
    echo INSTRUCTIONS - the part I cant do automatically
    echo A settings menu will appear after you hit return, in this menu at the top right there will be a button with the text import. Click it. A popup menu should appear, open the drpdown and select custom scheme then open file and navigate to the directory you cloned the repository into. Open autoconfig.kksrc in the file picker and click import.
    echo Apply the changes and set shortcuts to run the new entries
    kcmshell6 kcm_keys

else
    echo Not on supported Desktop Environment, Exiting
    echo Pass argument -f to force script to run, may cause problems
fi