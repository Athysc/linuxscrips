function burn_trash --description 'Empty trash on all mounted drives safely'
    echo "Scanning for trash on all drives..."

    # trash-empty is part of trash-cli. 
    # It automatically checks connected volumes for .Trash folders.
    trash-empty

    if test $status -eq 0
        echo "All trash bins emptied successfully."
    else
        echo "Error: Could not empty trash. Make sure you have permissions."
    end
end
