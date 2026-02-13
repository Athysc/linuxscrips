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
