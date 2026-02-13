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
