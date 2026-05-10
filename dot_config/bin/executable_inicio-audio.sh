#!/bin/bash
# Esperar a que el sistema termine de cargar
sleep 2
# Exportar variables necesarias para que Flatpak vea el display
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
# Lanzar JamesDSP (ID correcto)
flatpak run me.timschneeberger.jdsp4linux --tray &

