#!/bin/bash

echo "➤ Importando dotfiles a chezmoi…"

# Función para agregar archivos con verificación
add_file() {
  if [[ -e "$1" ]]; then
    ~/bin/chezmoi add "$1"
  else
    echo "⚠ Archivo no encontrado: $1"
  fi
}

# =======================
# Archivos en $HOME
# =======================

add_file ~/.zshrc
add_file ~/.zshenv
add_file ~/.p10k.zsh
add_file ~/.profile


# =======================
# Archivos en ~/.config
# =======================

# sway
add_file ~/.config/sway/config_backup
add_file ~/.config/sway/config

# foot
add_file ~/.config/foot/foot.ini
add_file ~/.config/foot/patch.diff

# Waybar - temas y scrips
add_file ~/.config/waybar/config.jsonc
add_file ~/.config/waybar/style.css
add_file ~/.config/waybar/scripts/network-info.sh
add_file ~/.config/waybar/scripts/sway-workspace-icons.sh
add_file ~/.config/waybar/scripts/sway-workspace-test.sh
add_file ~/.config/waybar/scripts/sway-debug.sh
add_file ~/.config/waybar/scripts/sway-icons.sh
add_file ~/.config/waybar/scripts/sway-icons_backup.sh
add_file ~/.config/waybar/scripts/network-ip.sh
add_file ~/.config/waybar/scripts/sway-robusto.sh
add_file ~/.config/waybar/scripts/volume-control.sh
chmod +x ~/.config/waybar/scripts/network-info.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-workspace-icons.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-workspace-test.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-debug.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-icons.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-icons_backup.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/network-ip.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-robusto.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/volume-control.sh 2>/dev/null

# Más compacto
#[ -d ~/.config/waybar ] && chezmoi add --recursive ~/.config/waybar
#chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null

# mc
add_file ~/.config/mc/ini
add_file ~/.config/mc/panels.ini

# mako-notifier
add_file ~/.config/mako/config
add_file ~/.config/mako/scripts/mpris-notify.sh
add_file ~/.config/mako/scripts/mpris-notify_backup.sh
chmod +x ~/.config/mako/scripts/mpris-notify.sh 2>/dev/null
chmod +x ~/.config/mako/scripts/mpris-notify_backup.sh 2>/dev/null

# =======================
# Directorios completos
# =======================

# Rofi
[ -d ~/.config/rofi ] && ~/bin/chezmoi add --recursive ~/.config/rofi

# MPD y NCMPCPP
add_file ~/.mpd/mpd.conf
[ -d ~/.mpd/playlists ] && ~/bin/chezmoi add --recursive ~/.mpd/playlists

add_file ~/.ncmpcpp/config
[ -d ~/.ncmpcpp/lyrics ] && ~/bin/chezmoi add --recursive ~/.ncmpcpp/lyrics


# =======================
# Temas de Oh my Posh
# =======================

add_file ~/.poshthemes/amro-mod.omp.json
add_file ~/.poshthemes/craver-mod.omp.json
add_file ~/.poshthemes/emodipt-extend-mod.omp.json
add_file ~/.poshthemes/kushal-mod.omp.json
add_file ~/.poshthemes/stelbent.minimal-mod.omp.json


# =======================
# Archivos en ~/.dotfiles
# =======================

# Aliases, functions y exports
add_file ~/.dotfiles/shell/_aliases/chezmoi.sh
add_file ~/.dotfiles/shell/_aliases/dir.sh
add_file ~/.dotfiles/shell/_aliases/git.sh
add_file ~/.dotfiles/shell/_aliases/utils.sh
add_file ~/.dotfiles/shell/_functions/extractPorts.sh
add_file ~/.dotfiles/shell/_functions/fzf-lovely.sh
add_file ~/.dotfiles/shell/_functions/man.sh
add_file ~/.dotfiles/shell/_functions/mkt.sh
add_file ~/.dotfiles/shell/_functions/rmk.sh
add_file ~/.dotfiles/shell/_functions/target.sh
add_file ~/.dotfiles/shell/_functions/zle-keymap-select.sh
add_file ~/.dotfiles/shell/init.sh
chmod +x ~/.dotfiles/shell/init.sh 2>/dev/null

# Documentos martdown
[ -d ~/.dotfiles/doc/md ] && ~/bin/chezmoi add --recursive ~/.dotfiles/doc/md

# Scripts
[ -d ~/.dotfiles/scripts ] && ~/bin/chezmoi add --recursive ~/.dotfiles/scripts

echo "✔ Listo. Revisa con 'chezmoi status' o guarda con Git."
