function select_function
    # 1. Dependency Check
    if not command -v rofi >/dev/null
        echo "Error: rofi is not installed." >&2
        return 1
    end

    set -l functions_dir ~/.config/fish/functions

    # 2. Define your whitelist line-by-line for readability
    set -l include_files \
        "clearclip.fish" \
        "cleartrash.fish" \
        "backupscripts.fish" \
        "killwow.fish" \
        "takescreenshot.fish" \
        "remmina-open.fish" \
        "editbackupscript.fish" \
        "editrofi.fish"

    # 3. Filter and Validate
    # We check if the file actually exists before adding it to the Rofi list
    set -l valid_functions
    for file in $include_files
        if test -f "$functions_dir/$file"
            # Strip the .fish extension for the Rofi display
            set -a valid_functions (string replace -r '\.fish$' '' $file)
        end
    end

    # 4. Display in Rofi
    # Using 'printf' to ensure newlines are handled correctly for Rofi's stdin
    set -l selected_function (printf "%s\n" $valid_functions | rofi -dmenu -p "Execute..." -theme ~/.config/rofi/catppuccin-dank.rasi)

    # 5. Execution
    if test -n "$selected_function"
        echo "Executing: $selected_function"
        # We call the function directly. Since fish autoloads from 
        # ~/.config/fish/functions, we don't need to 'source' it first.
        $selected_function
    end
end
