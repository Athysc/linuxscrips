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
