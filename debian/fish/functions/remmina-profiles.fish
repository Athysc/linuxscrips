function remmina-profiles --description 'List Remmina profiles (name -> file)'
    set -l dirs \
        "$HOME/.local/share/remmina" \
        "$HOME/.config/remmina" \
        "$HOME/.remmina" \
        "$HOME/.var/app/org.remmina.Remmina/data/remmina" \
        "$HOME/.var/app/org.remmina.Remmina/config/remmina" \
        "$HOME/snap/remmina/current/.local/share/remmina" \
        "$HOME/snap/remmina/common/.local/share/remmina"

    if set -q XDG_DATA_HOME
        set -a dirs "$XDG_DATA_HOME/remmina"
    end
    if set -q XDG_CONFIG_HOME
        set -a dirs "$XDG_CONFIG_HOME/remmina"
    end

    set -l files
    for d in $dirs
        test -d "$d"; or continue
        set -a files (command find "$d" -maxdepth 1 -type f -name '*.remmina' 2>/dev/null)
    end

    if test (count $files) -eq 0
        echo "No *.remmina profiles found in known locations." >&2
        return 1
    end

    for f in $files
        set -l name (command sed -n 's/^name=//p' "$f" | head -n 1 | string trim -r -c \r)
        if test -n "$name"
            printf "%s\t%s\n" "$name" "$f"
        end
    end | sort
end
