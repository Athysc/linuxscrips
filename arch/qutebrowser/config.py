import os
import catppuccin
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

if not os.path.exists(config.configdir / "theme.py"):
    theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
    with urlopen(theme) as themehtml:
        with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

if os.path.exists(config.configdir / "theme.py"):
    import theme
    theme.setup(c, 'mocha', True)
    
c.editor.command = ["ghostty", "-e", "helix", "{file}:{line}"]

c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}",
    "g":       "https://google.com/search?q={}",
    "aw":      "https://wiki.archlinux.org/index.php?search={}"
}

c.url.start_pages = ["https://google.com"]
c.url.default_page = "https://google.com"
