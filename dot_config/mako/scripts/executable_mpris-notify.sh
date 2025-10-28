#!/bin/bash
# Script de notificaciones para MPD/MPRIS con playerctl

ICON="$HOME/.icons/ePapirus-Dark/48x48/apps/mpd.svg"
STATEFILE="/tmp/mpd_last_track"
LOCKFILE="/tmp/mpd-notify.lock"
SLEEP_INTERVAL=1

# Intentar crear el archivo de bloqueo
if ! ( set -o noclobber; > "$LOCKFILE") 2>/dev/null; then
    echo "El script ya está en ejecución."
    exit 0
fi

# Asegurarse de eliminar el archivo de bloqueo al salir
trap 'rm -f "$LOCKFILE"' EXIT
touch "$LOCKFILE"

# Inicializa último track vacío
last_track=""

while true; do
    track=$(playerctl metadata --format '{{artist}} – {{title}}' 2>/dev/null | tr -d '\n')
    if [[ -n "$track" && "$track" != "$last_track" ]]; then
        notify-send -u low -i "$ICON" "Reproduciendo" "$track"
        last_track="$track"
        echo "$track" > "$STATEFILE"
    fi
    sleep $SLEEP_INTERVAL
done
