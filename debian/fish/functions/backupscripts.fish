function backupscripts

    # 1. Define the Root Backup Location
    set -l backup_root /mnt/AppData/WSpaceSC/LinuxScripts

    # --- INTERNAL HELPER FUNCTION ---
    # Usage: _smart_copy <root_path> <type> <source_path> <destination_subfolder_name>

    function _smart_copy --argument-names root_path type src_path dest_name

        # Construct the full destination path using the passed root
        set -l dest_full_path "$root_path/$dest_name"

        # A. Check if source exists
        if not test -e $src_path
            echo "⚠️  Warning: Source not found: $src_path"
            return
        end

        # B. Check and Create Destination Directory
        if not test -d $dest_full_path
            mkdir -p $dest_full_path
            echo "📁 Created new directory: $dest_full_path"
        end

        # C. Perform the Copy
        if test "$type" = dir
            # Copy directory contents recursively
            cp -r $src_path/* $dest_full_path/
        else
            # Copy a single file
            cp $src_path $dest_full_path/
        end

        # D. Report Status
        if test $status -eq 0
            echo "✅ $src_path -> Done"
        else
            echo "❌ Error: Failed to copy to $dest_full_path"
        end
    end
    # -------------------------------

    # === CONFIGURATION SECTION ===
    # Add your backup items below. 
    # Format: _smart_copy $backup_root <dir|file> <path> <backup_folder_name>

    # 1. Directories (Directory Mode)
    _smart_copy $backup_root dir "$HOME/.config/fish/functions" fish/functions
    _smart_copy $backup_root dir "$HOME/.config/yazi" yazi
    _smart_copy $backup_root dir "$HOME/.config/niri" niri

    # 2. Specific Files (File Mode)

    _smart_copy $backup_root file "$HOME/.config/fish/config.fish" fish
    _smart_copy $backup_root file "$HOME/.config/niri/config.kdl" niri
    _smart_copy $backup_root file "$HOME/.config/helix/config.toml" helix
    _smart_copy $backup_root file "$HOME/.config/helix/languages.toml" helix
    _smart_copy $backup_root file "$HOME/.config/samba/smb.config" samba
    _smart_copy $backup_root file "/etc/samba/smb.conf" samba_etc

end
