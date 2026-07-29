-- ▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖      ▗▄▖  ▗▄▄▖
-- ▐▛▚▖▐▌  █    █  ▐▌ ▐▌▐▌ ▐▌    ▐▌ ▐▌▐▌
-- ▐▌ ▝▜▌  █    █  ▐▛▀▚▖▐▌ ▐▌    ▐▌ ▐▌ ▝▀▚▖
-- ▐▌  ▐▌▗▄█▄▖  █  ▐▌ ▐▌▝▚▄▞▘    ▝▚▄▞▘▗▄▄▞▘
-- Github : @Nitro-OS

-- Applications
local terminal         = "alacritty"
local fileManager      = "ghostty -e yazi"
local menu             = "~/.config/rofi/launchers/launcher.sh"
local browser          = "/opt/zen-browser-bin/zen-bin"
local messenger        = "Telegram"
local camera           = "io.github.cosmic_utils.camera"
local obsidian         = "md.obsidian.Obsidian"
local wallpaperManager = "~/.config/rofi/wallpaper/wallpaper.sh"

local powermenu        = "~/.config/rofi/powermenu/powermenu.sh"
local clipboard        = "~/.config/rofi/clipboard/clipboard.sh"
local userMenu         = "~/.config/rofi/user/apps.sh"
local helpMenu         = "~/.config/rofi/help/help.sh"

local logout           = "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"

-- Keybindings
local mainMod          = "SUPER"

-- Applications
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(wallpaperManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(messenger))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(camera))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(obsidian))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("thunderbird"))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(logout))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen_state({ client = -1, internal = 1 }))

-- Screenshots
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("hyprshot -m window"))

-- Rofi utilities
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd(userMenu))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(helpMenu))

-- Navigation
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse controls
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media Keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
