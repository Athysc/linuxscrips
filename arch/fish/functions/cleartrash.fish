function cleartrash --description "Empty trash on all mounted drives safely"

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
