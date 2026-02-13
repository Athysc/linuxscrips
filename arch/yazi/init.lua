
require("bunny"):setup({
  hops = {
    { key = "/",          path = "/",                                    },
    { key = "t",          path = "/tmp",                                 },
    { key = "~",          path = "~",              desc = "Home"         },
    { key = "m",          path = "/mnt/AppData/WorkMusicMTV",        desc = "Work Music"        },
    { key = "D",          path = "~/Documents",      desc = "Documents"      },
    { key = "d",          path = "~/Downloads",    desc = "Downloads"    },
    { key = "c",          path = "~/.config",      desc = "Config files" },
    { key = { "l", "d" }, path = "/mnt/DownloadData/Downloads", desc = "D->Downloads"  },
    { key = { "l", "k" }, path = "/mnt/DownloadData/4KDownloads", desc = "D->4K Downloads"  },
    { key = { "l", "m" }, path = "/mnt/MediaData/MediaLibrary", desc = "D->Media Library"  },
    { key = { "l", "x" }, path = "/mnt/MyData/PFiles",   desc = "D->PFiles"    },
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true, -- Enable ephemeral hops, default is true
  tabs = true, -- Enable tab hops, default is true
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})
