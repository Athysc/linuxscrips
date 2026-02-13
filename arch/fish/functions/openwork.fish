function openwork --description 'Connect Remmina profile Work (Flatpak) without showing the picker'
    set -l profile "$HOME/.var/app/org.remmina.Remmina/data/remmina/work_rdp_work_192-168-68-62.remmina"

    if not test -f "$profile"
        echo "remmina-work: profile not found: $profile" >&2
        return 1
    end

    if type -q flatpak; and flatpak info org.remmina.Remmina >/dev/null 2>&1
        # Pass args straight to the Flatpak app
        flatpak run org.remmina.Remmina -c "$profile" >/dev/null 2>&1 & disown
        return 0
    end

    echo "remmina-work: Flatpak org.remmina.Remmina not available." >&2
    return 1
end
