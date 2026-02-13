function play-wow --description 'Launch WoW from /mnt without symlinks'
    # 1. Define Paths
    set faugus_prefix "$HOME/Faugus/Battle.net"
    set bnet_exe "$faugus_prefix/drive_c/Program Files (x86)/Battle.net/Battle.net.exe"
    set wow_path "/mnt/AppData/Wow/World of Warcraft/_retail_/Wow.exe"

    # 2. Cleanup stuck processes first
    pkill -9 -f "Agent.exe" >/dev/null 2>&1

    echo "Ensuring /mnt is recognized by Wine..."
    # This command maps your /mnt/AppData folder to the 'D:' drive inside the WoW prefix
    ln -sf /mnt/AppData "$faugus_prefix/dosdevices/d:"

    echo "Launching Battle.net..."

    # We use env to pass the WINEPREFIX directly to the faugus-launcher command
    # and tell Battle.net to launch the game using its internal 'launch' command.
    faugus-launcher "$bnet_exe" -- --exec="launch WoW" &

    echo "Waiting for Wow.exe to start..."

    set timeout 45
    while not pgrep -f "Wow.exe" >/dev/null
        sleep 2
        set timeout (math $timeout - 1)
        if test $timeout -eq 0
            echo "Error: WoW didn't start. Check if Battle.net settings point to D: drive."
            return 1
        end
    end

    echo "WoW detected! Cleaning up in 20 seconds..."
    sleep 20

    # Clean up the launcher background noise
    pkill -9 -f "Battle.net.exe"
    pkill -9 -f "Agent.exe"
    pkill -9 -f "BlizzardBrowser.exe"

    echo "Launcher closed. Good luck, Athy!"
end
