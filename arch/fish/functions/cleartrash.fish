function cleartrash --description "Empty trash on all mounted drives safely"

    # --- 1. Terminal Redirection Logic ---
    # If not in a terminal (e.g., called from Rofi), spawn Ghostty and run this function
    if not isatty stdout
        # 'bash -c' or 'fish -c' ensures the window stays open to show results
        # We use 'read' at the end so the window doesn't vanish instantly
        ghostty -e fish -c "backupscripts; echo -e '\nPress enter to close...'; read"
        return
    end

    echo "Invoking > gtrash summary"

    gtrash summary
    echo "--------------------------------->"

    rm -rf /mnt/DownloadData/.Trash-1000
    echo "Cleared DownloadData drive trash."

    rm -rf /mnt/MediaData/.Trash-1000
    echo "Cleared MediaData drive trash."

    rm -rf /mnt/AppData/.Trash-1000
    echo "Cleared AppData drive trash."

    rm -rf /mnt/MyData/.Trash-1000
    echo "Cleared MyData drive trash."

    echo "--------------------------------->"

    gtrash summary

end
