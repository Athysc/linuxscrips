# Function to launch an app, move it to a workspace, and resize it
function niri_launch_arrange
    set -l app_cmd $argv[1]
    set -l app_id_pattern $argv[2] # Regex or substring to match app_id/title
    set -l workspace_idx $argv[3]
    set -l width_percent $argv[4] # Optional: e.g., "50%"

    echo ">>> Processing: $app_cmd"

    # 1. Switch to the target workspace first
    # This ensures the app spawns "near" where we want it, or we can see it happen.
    niri msg action focus-workspace $workspace_idx

    # 2. Spawn the application
    # We use 'disown' to keep the script running independent of the app
    fish -c "$app_cmd" & disown

    # 3. Wait for the window to appear
    # We poll niri's window list until we find a match.
    # Timeout after 10 seconds to prevent infinite loops.
    set -l retries 20
    set -l window_id ""

    while test $retries -gt 0
        sleep 0.5
        # Get the ID of the most recently focused window that matches our pattern
        # Note: Niri focuses new windows by default, so checking 'focused' is usually safe.
        # For more precision, we check the whole list.
        set window_id (niri msg --json windows | jq -r ".[] | select(.app_id | contains(\"$app_id_pattern\")) | .id" | tail -n 1)

        if test -n "$window_id"
            break
        end
        set retries (math $retries - 1)
    end

    if test -z "$window_id"
        echo "Error: Timed out waiting for $app_cmd (Pattern: $app_id_pattern)"
        return 1
    end

    echo "Found window ID: $window_id. Applying layout..."

    # 4. Move to Workspace (Redundant if we focused first, but good for safety)
    niri msg action focus-window --id $window_id
    niri msg action move-window-to-workspace $workspace_idx

    # 5. Apply Proportions (Width)
    if test -n "$width_percent"
        # Convert "50%" to "0.5" for Niri if needed, or pass directly if Niri supports %
        # Niri IPC supports percentages directly in recent versions
        niri msg action set-column-width --id $window_id $width_percent
    end
end
