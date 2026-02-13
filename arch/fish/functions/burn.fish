function burn --description "Usage: burn <NewName> <files...>"
    # 1. The first argument is the new Name
    set base_name $argv[1]

    # 2. The rest of the arguments are the files (from Yazi)
    set files $argv[2..-1]

    if test -z "$base_name"
        # Safety catch: If you forgot the name, don't rename anything
        # (This echo might not be seen in non-interactive mode, but it prevents damage)
        return 1
    end

    set count 1

    for file in $files
        set ext (path extension "$file")
        set new_name (string printf "%s_%02d%s" "$base_name" "$count" "$ext")
        mv -n "$file" "$new_name"
        set count (math $count + 1)
    end
end
