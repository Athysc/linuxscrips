function killwow --description 'Force kill WoW, Battle.net, and Faugus Launcher'
    # List includes the game, the launcher, and the Faugus app itself
    set target_procs "Wow.exe" "Battle.net.exe" "Agent.exe" "BlizzardBrowser.exe" faugus-launcher

    echo "Initiating total shutdown of Blizzard and Faugus..."

    for proc in $target_procs
        if pgrep -f $proc >/dev/null
            echo "Terminating $proc..."
            # -9 is the 'force' flag (SIGKILL)
            # -f looks at the full command line (useful for .exe files)
            pkill -9 -f $proc
        end
    end

    # Specific check for faugus if pkill -f missed it
    pkill -9 faugus-launcher >/dev/null 2>&1

    echo "System cleaned. Everything is closed, Athy."
end
