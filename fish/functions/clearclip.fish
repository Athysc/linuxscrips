function clearclip --description "Clear system clipboards (clipboard + primary) and common clipboard history managers"
    set -l did_clear 0

    # --- Wayland (wl-clipboard) ---
    if set -q WAYLAND_DISPLAY; and type -q wl-copy
        printf '' | wl-copy
        printf '' | wl-copy --primary
        set did_clear 1
    end

    # --- X11 fallbacks ---
    if test $did_clear -eq 0
        if type -q xclip
            printf '' | xclip -selection clipboard
            printf '' | xclip -selection primary
            set did_clear 1
        else if type -q xsel
            printf '' | xsel --clipboard --input
            printf '' | xsel --primary --input
            set did_clear 1
        end
    end

    # --- Clipboard history managers (optional, but nice) ---
    if type -q cliphist
        cliphist wipe >/dev/null 2>&1
    end

    if type -q copyq
        copyq clear >/dev/null 2>&1
    end

    # KDE Klipper (if running)
    if type -q qdbus
        if qdbus | string match -q "org.kde.klipper"
            qdbus org.kde.klipper /klipper clearClipboardHistory >/dev/null 2>&1
            qdbus org.kde.klipper /klipper clearClipboardContents >/dev/null 2>&1
        end
    end

    if type -q notify-send
        notify-send "Clipboard cleared" "Clipboard + primary emptied (and history wiped where available)."
    else
        echo "✅ Clipboard cleared (and history wiped where available)."
    end
end
