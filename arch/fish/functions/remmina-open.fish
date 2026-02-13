function remmina-open --description 'Connect to Remmina profile by name (no picker)'

    # set -l profile_name $argv[1]
    set -l profile_name Work

    if test -z "$profile_name"
        echo "Usage: remmina-open <ProfileName>" >&2
        return 2
    end

    set -l match (remmina-profiles | awk -F'\t' -v n="$profile_name" '$1==n{print $2; exit}')

    if test -z "$match"
        echo "Profile not found: $profile_name" >&2
        echo "Available profiles:" >&2
        remmina-profiles >&2
        return 1
    end

    # Remmina can connect directly via -c/--connect FILE. :contentReference[oaicite:1]{index=1}
    command remmina -c "$match" >/dev/null 2>&1 & disown
end
