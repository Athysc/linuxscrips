function vidorganize --description "Organize files into folders based on 'Prefix - ' pattern"
    # Parse arguments
    set -l execute_mode 0

    for arg in $argv
        if contains -- $arg -x --execute
            set execute_mode 1
        end
    end

    # Inform user of current mode
    if test $execute_mode -eq 0
        echo (set_color yellow)"[DRY RUN] No files will be moved. Use -x or --execute to apply changes."(set_color normal)
    else
        echo (set_color green)"[EXECUTE] Moving files..."(set_color normal)
    end

    # Loop through files in the current directory
    for file in *
        # Skip if it is a directory
        if test -d "$file"
            continue
        end

        # Attempt to split the filename by " - "
        # format: prefix - suffix
        set -l parts (string split " - " -- "$file")

        # Ensure the split resulted in at least 2 parts (meaning the pattern exists)
        if test (count $parts) -ge 2
            set -l prefix $parts[1]
            set -l target_dir "$prefix"

            # VISUALIZATION LOGIC
            if test $execute_mode -eq 1
                # Create the directory if it doesn't exist
                if not test -d "$target_dir"
                    mkdir -p "$target_dir"
                    echo "Created directory: $target_dir"
                end

                # Move the file
                mv "$file" "$target_dir/"
                echo "Moved: $file -> $target_dir/"
            else
                # Dry run output
                echo "Would create: '$target_dir' and move '$file' into it."
            end
        end
    end
end
