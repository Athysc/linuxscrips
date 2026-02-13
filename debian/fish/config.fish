if status is-interactive
    # Commands to run in interactive sessions can go here
end

set gtk_theme "catppuccin-macchiato-pink-standard+default"
set icon_theme Papirus-Dark
set cursor_theme catppuccin-macchiato-dark-cursors
set font_name "JetBrainsMono Nerd Font 12"

# Apply to gsettings (for GTK4/Libadwaita apps)
gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme
gsettings set org.gnome.desktop.interface icon-theme $icon_theme
gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme
gsettings set org.gnome.desktop.interface font-name $font_name
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# Apply cursor size (optional, 24 is standard)
gsettings set org.gnome.desktop.interface cursor-size 24

# Set Environment variables for legacy apps
set -Ux GTK_THEME $gtk_theme
set -Ux XCURSOR_THEME $cursor_theme
set -Ux XCURSOR_SIZE 24

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
alias linuxscripts 'cd /mnt/AppData/WSpaceSC/LinuxScripts'

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

fastfetch

starship init fish | source

# load all functions files that contain more than one functions
source ~/.config/fish/functions/ytdlp.fish
