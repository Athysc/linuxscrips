function dmusic
    yt-dlp -x --audio-format mp3 --audio-quality 0 \
        --embed-thumbnail --embed-metadata \
        --quiet --progress \
        --progress-template "download:[\%(progress._percent_str)s] \%(progress._speed_str)s | ETA: \%(progress._eta_str)s | \%(info.title)s" \
        -o "%(title)s.%(ext)s" $argv
end
