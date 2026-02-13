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
