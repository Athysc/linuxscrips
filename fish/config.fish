if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/.local/bin

set -gx EDITOR hx
set -gx VISUAL hx

# set -gx EDITOR nvim
# set -gx VISUAL nvim

alias vim='nvim'
alias dolphin='flatpak run org.kde.dolphin &'

alias drivedev 'cd /mnt/AppData'
alias drivemedia 'cd /mnt/MediaData'
alias drivedata 'cd /mnt/MyData'
alias drivedownloads 'cd /mnt/DownloadData'
alias drivebackups 'cd /mnt/Backups'

# Common use
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias big 'expac -H M "%m\t%n" | sort -h | nl' # Sort installed packages according to size in MB (expac must be installed)
alias dir 'dir --color=auto'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias grubup 'sudo update-grub'
alias hw 'hwinfo --short' # Hardware Info
alias ip 'ip -color'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias rmpkg 'sudo pacman -Rdd'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias upd /usr/bin/garuda-update
alias vdir 'vdir --color=auto'
alias wget 'wget -c '

# Get the error messages from journalctl
alias jctl 'journalctl -p 3 -xb'

## Useful aliases
# Replace ls with eza
alias ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
alias lsz 'eza -al --color=always --total-size --group-directories-first --icons' # include file size
alias la 'eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll 'eza -l --color=always --group-directories-first --icons' # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

## Custom functions
# 
function pullvideos
    # Find files matching mp4 OR mkv OR avi (case insensitive) and move them to current dir
    find . -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" \) -exec mv -t . {} +
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function dvid
    if yt-dlp -f "bestvideo+bestaudio/best" \
            --merge-output-format mp4 \
            --no-warnings \
            --progress \
            --progress-template "download: [%(progress._percent_str)s] %(progress._speed_str)s | ETA: %(progress._eta_str)s" \
            --embed-subs --embed-thumbnail --embed-metadata \
            -o "%(title)s.%(ext)s" $argv

        set_color green
        echo "✔ Download Completed Successfully: $argv"
        set_color normal
    else
        set_color red
        echo "✘ Download Failed: $argv"
        set_color normal
    end
end

function dmusic
    yt-dlp -x --audio-format mp3 --audio-quality 0 \
        --embed-thumbnail --embed-metadata \
        --quiet --progress \
        --progress-template "download:[\%(progress._percent_str)s] \%(progress._speed_str)s | ETA: \%(progress._eta_str)s | \%(info.title)s" \
        -o "%(title)s.%(ext)s" $argv
end

function dpl
    yt-dlp -f "bestvideo+bestaudio/best" \
        --merge-output-format mp4 \
        --yes-playlist \
        --download-archive archived_videos.txt \
        --quiet --progress \
        --progress-template "download:[\%(progress._percent_str)s] \%(progress._speed_str)s | ETA: \%(progress._eta_str)s | \%(info.title)s" \
        --embed-subs --embed-thumbnail --embed-metadata \
        -o "%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" $argv

    notify-send "Download Complete" "The playlist has been saved to your current folder." --icon=download
end

function dplaylist --description "Download a YouTube playlist via yt-dlp (robust + per-video progress)"
    if test (count $argv) -lt 1
        echo "Usage: dpl <playlist-or-video-url>"
        return 2
    end

    set -l url $argv[1]

    # Try to avoid the SABR-only / missing-URL situation by:
    # - using the "actual" player JS version
    # - preferring default clients plus web_embedded (helps for some videos)
    # Extractor-args are semicolon-separated. (See yt-dlp man page)
    set -l yt_extractor_args "youtube:player_js_version=actual;player_client=default,web_embedded"

    yt-dlp \
        -f "bestvideo*+bestaudio/best" \
        --merge-output-format mp4 \
        --yes-playlist \
        --download-archive archived_videos.txt \
        --ignore-errors \
        --no-warnings \
        --progress \
        --newline \
        --progress-template "download:[%(info.playlist_index)s/%(info.playlist_count)s] %(info.title).60s | %(progress._percent_str)s | %(progress._speed_str)s | ETA %(progress._eta_str)s" \
        --embed-subs --embed-thumbnail --embed-metadata \
        --extractor-args "$yt_extractor_args" \
        -o "%(playlist_title)s/%(playlist_index)03d - %(title)s.%(ext)s" \
        $url

    set -l st $status

    if test $st -eq 0
        notify-send "Download Complete" "yt-dlp finished successfully." --icon=download
    else
        notify-send "Download Finished (with errors)" "Some items failed, but the run continued." --icon=dialog-warning
    end

    return 0
end

function dplaylisten --description "Download a YouTube playlist via yt-dlp (robust + per-video progress)"
    if test (count $argv) -lt 1
        echo "Usage: dpl <playlist-or-video-url>"
        return 2
    end

    set -l url $argv[1]

    # Extractor-args are semicolon-separated.
    set -l yt_extractor_args "youtube:player_js_version=actual;player_client=default,web_embedded"

    yt-dlp \
        -f "bestvideo*+bestaudio/best" \
        --merge-output-format mp4 \
        --yes-playlist \
        --download-archive archived_videos.txt \
        --ignore-errors \
        --no-warnings \
        --progress \
        --newline \
        --progress-template "download:[%(info.playlist_index)s/%(info.playlist_count)s] %(info.title).60s | %(progress._percent_str)s | %(progress._speed_str)s | ETA %(progress._eta_str)s" \
        --embed-subs \
        --sub-langs "en.*" \
        --embed-thumbnail --embed-metadata \
        --extractor-args "$yt_extractor_args" \
        -o "%(playlist_title)s/%(playlist_index)03d - %(title)s.%(ext)s" \
        $url

    set -l st $status

    if test $st -eq 0
        notify-send "Download Complete" "yt-dlp finished successfully." --icon=download
    else
        notify-send "Download Finished (with errors)" "Some items failed, but the run continued." --icon=dialog-warning
    end

    return 0
end

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

function extract
    if test -z "$argv"
        # Display help if no argument is given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        if test -f "$argv"
            switch $argv
                case '*.tar.bz2'
                    tar xvjf $argv
                case '*.tar.gz'
                    tar xvzf $argv
                case '*.tar.xz'
                    tar xvJf $argv
                case '*.bz2'
                    bunzip2 $argv
                case '*.rar'
                    unrar x $argv
                case '*.gz'
                    gunzip $argv
                case '*.tar'
                    tar xvf $argv
                case '*.tbz2'
                    tar xvjf $argv
                case '*.tgz'
                    tar xvzf $argv
                case '*.zip'
                    unzip $argv
                case '*.Z'
                    uncompress $argv
                case '*.7z'
                    7z x $argv
                case '*.xz'
                    unxz $argv
                case '*'
                    echo "extract: '$argv' - unknown archive method"
            end
        else
            echo "$argv - file does not exist"
        end
    end
end

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

fastfetch

starship init fish | source
