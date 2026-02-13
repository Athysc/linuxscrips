function pullvideos
    # Find files matching mp4 OR mkv OR avi (case insensitive) and move them to current dir
    find . -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" \) -exec mv -t . {} +
end
