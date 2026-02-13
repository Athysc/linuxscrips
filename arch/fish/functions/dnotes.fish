function dnotes
    # Define the target directory
    set -l note_dir /mnt/AppData/WSpaceSC/MyNotes

    # Generate filename with today's date (YYYY-MM-DD)
    set -l today (date +%Y-%m-%d)
    set -l note_file "$note_dir/$today.md"

    # Ensure the directory exists
    if not test -d $note_dir
        mkdir -p $note_dir
    end

    # If file does not exist, create it with a header
    if not test -f $note_file
        echo "# Daily Notes: $today" >$note_file
        echo "" >>$note_file
        echo "Created new daily note: $note_file"
    end

    # Open in Helix.
    # Helix uses 'filename:line' format. 
    # We append ':999999' to force it to open at the very bottom.
    hx "$note_file:999999"
end
