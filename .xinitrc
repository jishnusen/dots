# X Config
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xset s 0 0
xset s off
xset dpms 300 300 300
xsetroot -cursor_name left_ptr

export XDG_SESSION_TYPE=X11

# So QT theming works
export QT_QPA_PLATFORMTHEME=qt6ct

# auth
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
ssh-add


# CATPPUCCIN
export CAT_ROSEWATER="#f5e0dc"
export CAT_FLAMINGO="#f2cdcd"
export CAT_PINK="#f5c2e7"
export CAT_MAUVE="#cba6f7"
export CAT_RED="#f38ba8"
export CAT_MAROON="#eba0ac"
export CAT_PEACH="#fab387"
export CAT_YELLOW="#f9e2af"
export CAT_GREEN="#a6e3a1"
export CAT_TEAL="#94e2d5"
export CAT_SKY="#89dceb"
export CAT_SAPPHIRE="#74c7ec"
export CAT_BLUE="#89b4fa"
export CAT_LAVENDER="#b4befe"
export CAT_TEXT="#cdd6f4"
export CAT_SUBTEXT1="#bac2de"
export CAT_SUBTEXT0="#a6adc8"
export CAT_OVERLAY2="#9399b2"
export CAT_OVERLAY1="#7f849c"
export CAT_OVERLAY0="#6c7086"
export CAT_SURFACE2="#585b70"
export CAT_SURFACE1="#45475a"
export CAT_SURFACE0="#313244"
export CAT_BASE="#1e1e2e"
export CAT_MANTLE="#181825"
export CAT_CRUST="#11111b"

# wm
exec bspwm

# vim: syntax=sh
