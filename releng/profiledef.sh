#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="nitroos"
iso_label="NITROOS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="NitroOS (based on Arch Linux) <https://github.com/nitroos>"
iso_application="NitroOS Live System (Arch-based)"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/home/nitroos"]="1000:998:750"
  ["/home/nitroos/.automated_script.sh"]="1000:998:755"
  ["/home/nitroos/.zlogin"]="1000:998:644"
  ["/home/nitroos/.zshrc"]="1000:998:644"
  ["/etc/sudoers.d"]="0:0:755"
  ["/etc/sudoers.d/10-nitroos"]="0:0:440"
  ["/etc/skel/.config/hypr/scripts/battery.sh"]="0:0:755"
  ["/etc/skel/.config/hypr/scripts/wallpaper.sh"]="0:0:755"
  ["/etc/skel/.config/rofi/clipboard/clipboard.sh"]="0:0:755"
  ["/etc/skel/.config/rofi/help/help.sh"]="0:0:755"
  ["/etc/skel/.config/rofi/launchers/launcher.sh"]="0:0:755"
  ["/etc/skel/.config/rofi/powermenu/powermenu.sh"]="0:0:755"
  ["/etc/skel/.config/rofi/user/apps.sh"]="0:0:755"
  ["/etc/skel/.config/rofi/wallpaper/wallpaper.sh"]="0:0:755"
  ["/etc/skel/.config/waybar/scripts/hyprsunset-status.sh"]="0:0:755"
  ["/etc/skel/.config/waybar/scripts/hyprsunset-toggle.sh"]="0:0:755"
  ["/etc/skel/.config/waybar/scripts/power.sh"]="0:0:755"
  ["/usr/local/bin/nhttp"]="0:0:755"
  ["/usr/local/bin/npk"]="0:0:755"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
)
