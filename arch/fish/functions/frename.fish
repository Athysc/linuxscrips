function frename
    set -l pattern $argv[1]
    set -l new_base $argv[2]
    set -l i 1

    for file in *
        # Match using regex and ensure it's a file
        if test -f "$file"; and string match -qr "$pattern" "$file"
            # Extract extension including the dot
            set -l ext (string match -r '\.[^.]+$' "$file")

            # Format new name with 3-digit padded number
            set -l new_name (printf "%s %03d%s" "$new_base" "$i" "$ext")

            echo "Renaming: $file -> $new_name"
            mv "$file" "$new_name"

            set i (math $i + 1)
        end
    end
end
