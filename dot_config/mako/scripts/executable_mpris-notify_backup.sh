#!/bin/bash
# Script para enviar notificaciones de música vía mako
# Funciona con cualquier reproductor compatible con MPRIS
# Evita duplicados y retrasos con streams de radio

# Evita múltiples instancias al recargar sway
if pgrep -x "mpd-notify.sh" > /dev/null; then
    exit 0
fi

last_track=""

while true; do
    # Obtiene artista y título del reproductor activo
    track=$(playerctl metadata --format '{{artist}} – {{title}}' 2>/dev/null)

    # Si la canción cambió y no está vacía
    if [[ "$track" != "$last_track" && -n "$track" ]]; then
        # Envía notificación a mako
        notify-send -i /home/alex/.icons/ePapirus-Dark/48x48/apps/mpd.svg "Reproduciendo" "$track"
        last_track="$track"
    fi

    # Intervalo de comprobación
    sleep 1
done
