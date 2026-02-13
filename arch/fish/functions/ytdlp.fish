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

function ytdplaylist --description "Download YouTube via yt-dlp using OAuth2"
    if test (count $argv) -lt 1
        echo "Usage: dplaylist <playlist-or-video-url>"
        return 2
    end

    set -l url $argv[1]

    # Extractor args: Keep these, they help disguise the client
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
        --username oauth2 --password '' \
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

function dplaylist --description "Download a YouTube playlist via yt-dlp (cookies from browser)"
    if test (count $argv) -lt 1
        echo "Usage: dplaylist <playlist-or-video-url>"
        return 2
    end

    set -l url $argv[1]

    # CHANGE THIS to your browser: firefox, chrome, brave, chromium, etc.
    # set -l browser helium-browser
    set -l browser brave

    # Extractor args to help avoid bot detection
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
        --cookies-from-browser $browser \
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

function dplaylist2 --description "Download a YouTube playlist via yt-dlp (robust + per-video progress)"
    if test (count $argv) -lt 1
        echo "Usage: dpl <playlist-or-video-url>"
        return 2
    end

    set -l url $argv[1]
    # Define the path to your cookies file here
    set -l cookies_file "~/Documents/cookies.txt"

    # Extractor args
    set -l yt_extractor_args "youtube:player_js_version=actual;player_client=default,web_embedded"

    # Prepare base command
    set -l cmd yt-dlp \
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
        -o "%(playlist_title)s/%(playlist_index)03d - %(title)s.%(ext)s"

    # Conditionally add cookies if the file exists
    if test -f $cookies_file
        set cmd $cmd --cookies $cookies_file
        # set cmd $cmd --cookies-from-browser helium-browser
    else
        echo "Warning: $cookies_file not found. Proceeding without cookies."
    end

    # Run the command
    $cmd $url

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
