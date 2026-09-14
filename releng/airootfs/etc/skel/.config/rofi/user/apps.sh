#!/usr/bin/env bash

dir="$HOME/.config/rofi/user"
theme="$dir/style.rasi"

prompt='Applications'
mesg="Installed Packages : $(pacman -Q | wc -l) (pacman)"

list_col=6
list_row=1

term_cmd='alacritty'
file_cmd='dolphin'
btop_cmd='alacritty -e btop'
web_cmd='firefox'
launcher_cmd="$HOME/.config/rofi/launchers/launcher.sh"
nvim_cmd="alacritty -e nvim $HOME/.config/hypr/"

layout=$(grep 'USE_ICON' "$theme" 2>/dev/null | cut -d'=' -f2)

if [[ "$layout" == 'NO' ]]; then
	option_1=" Terminal <span weight='light' size='small'><i>($term_cmd)</i></span>"
	option_2=" Files <span weight='light' size='small'><i>($file_cmd)</i></span>"
	option_3=" btop <span weight='light' size='small'><i>($btop_cmd)</i></span>"
	option_4=" Browser <span weight='light' size='small'><i>($web_cmd)</i></span>"
	option_5=" App Launcher <span weight='light' size='small'><i>($launcher_cmd)</i></span>"
	option_6=" nvim <span weight='light' size='small'><i>($nvim_cmd)</i></span>"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
	option_6=""
fi

rofi_cmd() {
	rofi \
		-theme "$theme" \
		-theme-str "listview { columns: $list_col; lines: $list_row; }" \
		-theme-str 'textbox-prompt-colon { str: ""; }' \
		-dmenu \
		-i \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows
}

run_rofi() {
	printf '%s\n' \
		"$option_1" \
		"$option_2" \
		"$option_3" \
		"$option_4" \
		"$option_5" \
		"$option_6" |
		rofi_cmd
}

run_cmd() {
	case "$1" in
		--opt1) eval "$term_cmd" ;;
		--opt2) eval "$file_cmd" ;;
		--opt3) eval "$btop_cmd" ;;
		--opt4) eval "$web_cmd" ;;
		--opt5) eval "$launcher_cmd" ;;
		--opt6) eval "$nvim_cmd" ;;
	esac
}

chosen="$(run_rofi)"

case "$chosen" in
	"$option_1") run_cmd --opt1 ;;
	"$option_2") run_cmd --opt2 ;;
	"$option_3") run_cmd --opt3 ;;
	"$option_4") run_cmd --opt4 ;;
	"$option_5") run_cmd --opt5 ;;
	"$option_6") run_cmd --opt6 ;;
esac
