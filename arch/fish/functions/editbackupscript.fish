function editbackupscript
    # Use $HOME instead of ~ to ensure the path is absolute and 
    # recognized by GUI launchers like Rofi/Niri.
    set -l target_file "$HOME/.config/fish/functions/backupscripts.fish"

    if isatty stdout
        # Already in a terminal: Run helix directly
        hx "$target_file"
    else
        # From Rofi: Tell Ghostty to run a fish command that launches helix.
        # This ensures all your fish variables and paths are loaded.
        ghostty -e fish -c "hx $target_file"
    end
end
