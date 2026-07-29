-- ▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖      ▗▄▖  ▗▄▄▖
-- ▐▛▚▖▐▌  █    █  ▐▌ ▐▌▐▌ ▐▌    ▐▌ ▐▌▐▌
-- ▐▌ ▝▜▌  █    █  ▐▛▀▚▖▐▌ ▐▌    ▐▌ ▐▌ ▝▀▚▖
-- ▐▌  ▐▌▗▄█▄▖  █  ▐▌ ▐▌▝▚▄▞▘    ▝▚▄▞▘▗▄▄▞▘
-- Github : @Nitro-OS

hl.on("hyprland.start", function()
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd('sh -c "sleep 1 && $HOME/.config/hypr/scripts/wallpaper.sh"')
  hl.exec_cmd("numlockx on")
  hl.exec_cmd("waybar")
  hl.exec_cmd("mako")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
