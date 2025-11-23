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
add_file ~/.zprofile

# =======================
# Archivos en ~/.config
# =======================

# sway
add_file ~/.config/sway/config_backup
add_file ~/.config/sway/config
add_file ~/.config/sway/env

# foot
add_file ~/.config/foot/foot.ini
add_file ~/.config/foot/patch.diff

# Waybar - temas y scrips
chmod +x ~/.config/waybar/scripts/network-info.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-workspace-icons.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-workspace-test.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-debug.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-icons.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-icons_backup.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/network-ip.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/sway-robusto.sh 2>/dev/null
chmod +x ~/.config/waybar/scripts/volume-control.sh 2>/dev/null
add_file ~/.config/waybar/config.jsonc
add_file ~/.config/waybar/style.css
add_file ~/.config/waybar/config-bakup.jsonc
add_file ~/.config/waybar/scripts/network-info.sh
add_file ~/.config/waybar/scripts/sway-workspace-icons.sh
add_file ~/.config/waybar/scripts/sway-workspace-test.sh
add_file ~/.config/waybar/scripts/sway-debug.sh
add_file ~/.config/waybar/scripts/sway-icons.sh
add_file ~/.config/waybar/scripts/sway-icons_backup.sh
add_file ~/.config/waybar/scripts/network-ip.sh
add_file ~/.config/waybar/scripts/sway-robusto.sh
add_file ~/.config/waybar/scripts/volume-control.sh

# Más compacto
#[ -d ~/.config/waybar ] && chezmoi add --recursive ~/.config/waybar
#chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null

# mc
add_file ~/.config/mc/ini
add_file ~/.config/mc/panels.ini

# mako-notifier
chmod +x ~/.config/mako/scripts/mpris-notify.sh 2>/dev/null
chmod +x ~/.config/mako/scripts/mpris-notify_backup.sh 2>/dev/null
add_file ~/.config/mako/config
add_file ~/.config/mako/scripts/mpris-notify.sh
add_file ~/.config/mako/scripts/mpris-notify_backup.sh

# glow
add_file ~/.config/glow/glow.yml

# bin
chmod +x ~/.config/bin/mpdris2-rs-wrapper.sh 2>/dev/null
add_file ~/.config/bin/mpdris2-rs-wrapper.sh

# dunst
add_file ~/.config/dunst/dunstrc

# gtk-2.0
add_file ~/.config/gtk-2.0/gtkfilechooser.ini

# gtk-3.0
add_file ~/.config/gtk-3.0/settings.ini

# kitty
add_file ~/.config/kitty/color.ini
add_file ~/.config/kitty/kitty.conf

# mpdris2
add_file ~/.config/mpdris2-rs/config.toml

# nwg-look
add_file ~/.config/nwg-look/config

# Oh My Tmux
add_file ~/.config/oh-my-tmux/themes/dracula.conf

# systemd
add_file ~/.config/systemd/user/dunst.service
add_file ~/.config/systemd/user/swaync.service
add_file ~/.config/systemd/user/default.target.wants/mpd.service
add_file ~/.config/systemd/user/default.target.wants/mpdris2-rs.service

# xsettingsd
add_file ~/.config/xsettingsd/xsettingsd.conf

# =======================
# Directorios completos
# =======================

# RMPC
[ -d ~/.config/rmpc ] && ~/bin/chezmoi add --recursive ~/.config/rmpc

# Rofi
[ -d ~/.config/rofi ] && ~/bin/chezmoi add --recursive ~/.config/rofi

# MPD y NCMPCPP
add_file ~/.mpd/mpd.conf
[ -d ~/.mpd/playlists ] && ~/bin/chezmoi add --recursive ~/.mpd/playlists

add_file ~/.ncmpcpp/config
[ -d ~/.ncmpcpp/lyrics ] && ~/bin/chezmoi add --recursive ~/.ncmpcpp/lyrics

# Zellij
[ -d ~/.config/zellij ] && ~/bin/chezmoi add --recursive ~/.config/zellij


# =======================
# Temas de Oh my Posh
# =======================

add_file ~/.poshthemes/amro-mod.omp.json
add_file ~/.poshthemes/craver-mod.omp.json
add_file ~/.poshthemes/craver-mod2.omp.json
add_file ~/.poshthemes/emodipt-extend-mod.omp.json
add_file ~/.poshthemes/kushal-mod.omp.json
add_file ~/.poshthemes/stelbent.minimal-mod.omp.json


# =======================
# Archivos en ~/.dotfiles
# =======================

# Aliases, functions y exports
[ -d ~/.dotfiles/shell/_aliases ] && ~/bin/chezmoi add --recursive ~/.dotfiles/shell/_aliases
[ -d ~/.dotfiles/shell/_functions ] && ~/bin/chezmoi add --recursive ~/.dotfiles/shell/_functions
chmod +x ~/.dotfiles/shell/init.sh 2>/dev/null
add_file ~/.dotfiles/shell/init.sh

# Documentos markdown
[ -d ~/.dotfiles/doc/md ] && ~/bin/chezmoi add --recursive ~/.dotfiles/doc/md

# Scripts
chmod +x ~/.dotfiles/scripts/chezmoi-import.sh 2>/dev/null
chmod +x ~/.dotfiles/scripts/install-zellij.sh 2>/dev/null
chmod +x ~/.dotfiles/scripts/monitoreo-izzi.sh 2>/dev/null
chmod +x ~/.dotfiles/scripts/HDDs/Lightman/mount_drives.sh 2>/dev/null
chmod +x ~/.dotfiles/scripts/HDDs/Lightman/umount_drives.sh 2>/dev/null
[ -d ~/.dotfiles/scripts ] && ~/bin/chezmoi add --recursive ~/.dotfiles/scripts

# Services
chmod +x ~/.dotfiles/services/mount-hdds/jellyfin/mount_media_disks.sh 2>/dev/null
chmod +x ~/.dotfiles/services/mount-hdds/Lightman/mount_drives.sh 2>/dev/null
chmod +x ~/.dotfiles/services/mount-hdds/Lightman/umount_drives.sh 2>/dev/null
chmod +x ~/.dotfiles/services/mount-hdds/mount-disks/mount-disks.sh 2>/dev/null
[ -d ~/.dotfiles/services ] && ~/bin/chezmoi add --recursive ~/.dotfiles/services

echo "✔ Listo. Revisa con 'chezmoi status' o guarda con Git."
