function lgscripts --description "Open lazygit for linuxscripts in a new Ghostty if called from Rofi"
    set -l repo_path /mnt/AppData/repos/linuxscripts

    # --- 1. Terminal Redirection Logic ---
    # Check if we are NOT in a terminal (e.g., invoked via Rofi/Runic)
    if not isatty stdout
        # ghostty -e launches the command
        # We cd to the repo first, then launch lazygit
        ghostty --working-directory=$repo_path -e fish -c lazygit
        return
    end

    # --- 2. Standard Terminal Logic ---
    # If already in a terminal, just jump to the dir and launch
    cd $repo_path
    lazygit
end
