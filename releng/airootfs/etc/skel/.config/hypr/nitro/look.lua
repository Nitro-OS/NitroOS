-- ▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖      ▗▄▖  ▗▄▄▖
-- ▐▛▚▖▐▌  █    █  ▐▌ ▐▌▐▌ ▐▌    ▐▌ ▐▌▐▌
-- ▐▌ ▝▜▌  █    █  ▐▛▀▚▖▐▌ ▐▌    ▐▌ ▐▌ ▝▀▚▖
-- ▐▌  ▐▌▗▄█▄▖  █  ▐▌ ▐▌▝▚▄▞▘    ▝▚▄▞▘▗▄▄▞▘
-- Github : @Nitro-OS

hl.config({
  general = {
    gaps_in          = 5,
    gaps_out         = 10,
    border_size      = 2,
    col              = {
      active_border   = { colors = { "rgba(7fbf7fff)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },
    resize_on_border = false,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = 10,
    rounding_power   = 2,
    active_opacity   = 1.0,
    inactive_opacity = 1.0,
    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },
    blur             = {
      enabled  = true,
      size     = 3,
      passes   = 3,
      vibrancy = 0.1696,
      noise    = 0.3
    },
  },

  animations = {
    enabled = true,
  },
})

hl.config({
  dwindle = {
    preserve_split = true,
  },
})

hl.config({
  master = {
    new_status = "master",
  },
})

hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
  },
})

hl.config({
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
  },
})
