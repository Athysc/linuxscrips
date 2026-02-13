# Example: specialized coding workspace on Workspace 1
# Arguments: "command" "match_string" workspace_index "width"
function loadapps

    niri_launch_arrange helium-browser helium 1 "40%"

    niri_launch_arrange discord discord 2 "20%"
    niri_launch_arrange haruna "org.kde.haruna" 2 "40%"
    niri_launch_arrange "ghostty --working-directory /mnt/AppData/WorkMusicMTV" ghostty 2 "40%"

    niri_launch_arrange ghostty "com.mitchellh.ghostty" 3 "20%"
    niri_launch_arrange "remmina -c $HOME/.local/share/remmina/work_rdp_work_192-168-68-62.remmina" remmina 3 "60%"
    niri_launch_arrange helium-browser helium 3 "20%"

end
