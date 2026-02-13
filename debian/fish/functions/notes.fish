function notes
    # Define the target directory and file
    set -l note_dir /mnt/AppData/WSpaceSC/MyNotes
    set -l note_file "$note_dir/tempnotes.md"

    # Ensure the directory exists (creates parent dirs if needed)
    if not test -d $note_dir
        mkdir -p $note_dir
    end

    # If file doesn\'t exist, create it (touch)
    if not test -f $note_file
        touch $note_file
        echo "Created new scratchpad: $note_file"
    end

    # Open in Helix
    hx $note_file
end
