#!/bin/fish

# 1. Set the save location
set filename "$HOME/Pictures/Screenshots/Screenshot_"(date +%Y%m%d_%H%M%S)".png"

# 2. Ensure the directory exists
mkdir -p "$HOME/Pictures/Screenshots"

# 3. Run the pipeline
# grim (capture) -> slurp (select region) -> swappy (annotate)
# swappy outputs the final image to stdout (-o -), which we tee to a file AND wl-copy
grim -g (slurp) - | swappy -f - -o - | tee "$filename" | wl-copy

# 4. Optional: Send a notification (requires libnotify)
notify-send "Screenshot Saved" "Saved to $filename and copied to clipboard."
