function lcase
    # Find all files and directories depth-first
    find . -depth | while read -l path
        set -l dir (dirname $path)
        set -l base (basename $path)
        set -l new_base (string lower $base)

        # Only proceed if the name needs changing
        if test $base != $new_base
            # Safety check: prevent overwriting existing files
            if test -e "$dir/$new_base"
                set_color yellow
                echo "Skipping: $path ($new_base already exists)"
                set_color normal
            else
                mv "$path" "$dir/$new_base"
                set_color green
                echo "Renamed: $base -> $new_base"
                set_color normal
            end
        end
    end
end
