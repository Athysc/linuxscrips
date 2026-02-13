function backupscripts
    # --- 1. Terminal Redirection Logic ---
    # If not in a terminal (e.g., called from Rofi), spawn Ghostty and run this function
    if not isatty stdout
        # 'bash -c' or 'fish -c' ensures the window stays open to show results
        # We use 'read' at the end so the window doesn't vanish instantly
        ghostty -e fish -c "backupscripts; echo -e '\nPress enter to close...'; read"
        return
    end

    # --- 2. Main Logic (The "Work") ---
    # Define the Root Backup Location
    set -l backup_root /mnt/AppData/repos/linuxscripts/arch

    # Helper function definition
    function _smart_copy --argument-names root_path type src_path dest_name
        set -l dest_full_path "$root_path/$dest_name"
        set -l expanded_src

        if test "$type" = file
            eval set expanded_src $src_path
        else
            set expanded_src $src_path
        end

        if test (count $expanded_src) -eq 0
            echo "⚠️  Warning: Source not found or no files match: $src_path"
            return
        end

        if not test -d $dest_full_path
            mkdir -p $dest_full_path
            echo "📁 Created new directory: $dest_full_path"
        end

        if test "$type" = dir
            cp -r $src_path/* $dest_full_path/
        else
            cp $expanded_src $dest_full_path/
        end

        if test $status -eq 0
            if test (count $expanded_src) -gt 1
                echo "✅ $src_path (Wildcard) -> Done"
            else
                echo "✅ $src_path -> Done"
            end
        else
            echo "❌ Error: Failed to copy to $dest_full_path"
        end
    end

    # === CONFIGURATION SECTION ===
    echo "Starting backup to $backup_root..."
    echo -----------------------------------

    # Directories
    _smart_copy $backup_root dir "$HOME/.config/fish/functions" fish/functions
    _smart_copy $backup_root dir "$HOME/.config/niri" niri
    _smart_copy $backup_root dir "$HOME/.config/niri/dms" niri/dm
    _smart_copy $backup_root dir "$HOME/.local/share/jrnl" jrnl_data
    _smart_copy $backup_root dir "$HOME/.config/rofi" rofi

    # Files

    _smart_copy $backup_root file "$HOME/.taskrc" homeroot
    _smart_copy $backup_root file "$HOME/.nbrc" homeroot

    _smart_copy $backup_root file "$HOME/.config/starship.toml" configroot
    _smart_copy $backup_root file "$HOME/.config/fish/config.fish" fish
    _smart_copy $backup_root file "$HOME/.config/niri/config.kdl" niri
    _smart_copy $backup_root file "/etc/samba/smb.conf" samba_etc
    _smart_copy $backup_root file "$HOME/.config/jrnl/jrnl.yaml" jrnl
    _smart_copy $backup_root file "$HOME/.local/share/media-downloader/settings/settings.ini" local/share/media-downloader/settings
    _smart_copy $backup_root file "/etc/udev/rules.d/92-keychron.rules" etc/udev/rules.d
    _smart_copy $backup_root file "$HOME/.config/yazi/*.toml" yazi
    _smart_copy $backup_root file "$HOME/.config/helix/*.toml" helix

    echo -----------------------------------
    echo "Backup Complete!"
end
