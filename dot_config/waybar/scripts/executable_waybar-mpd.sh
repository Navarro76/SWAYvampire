#!/bin/bash

# Función para verificar si lo que suena en MPD es una radio online
check_if_mpd_stream() {
    FILE_SOURCE=$(mpc -f %file% current 2>/dev/null)
    MPD_STATUS=$(mpc status "%state%" 2>/dev/null)
    if [[ "$FILE_SOURCE" =~ :// ]] || { [ -z "$FILE_SOURCE" ] && [ "$MPD_STATUS" = "playing" ]; }; then
        echo 1
    else
        echo 0
    fi
}

# Sacudir D-Bus para que Firefox tome el control inmediato
force_dbus_switch() {
    # Buscamos si hay otro reproductor activo (Firefox, Feishin, etc.) que no sea MPD
    OTHER_PLAYER=$(playerctl -l 2>/dev/null | grep -v "mpd" | head -n 1)
    
    if [ -n "$OTHER_PLAYER" ]; then
        # El bofetón relámpago imperceptible que destruye la caché muerta de MPD
        (playerctl --player="$OTHER_PLAYER" pause; playerctl --player="$OTHER_PLAYER" play) >/dev/null 2>&1 &
    fi
    
    # Esperar un parpadeo de milisegundos y despertar el módulo mpris de Waybar
    (sleep 0.05; pkill -RTMIN+5 waybar) &
}

# Controlador del Clic Universal Inteligente (Play/Pause)
handle_toggle() {
    MPD_STATUS=$(mpc status "%state%" 2>/dev/null)

    if [ "$MPD_STATUS" = "playing" ]; then
        IS_STREAM=$(check_if_mpd_stream)

        if [ "$IS_STREAM" -eq 1 ]; then
            mpc stop >/dev/null 2>&1
            force_dbus_switch
        else
            playerctl --player=mpd play-pause >/dev/null 2>&1
        fi
    else
        playerctl play-pause >/dev/null 2>&1
    fi
    
    (sleep 0.05; pkill -RTMIN+5 waybar) &
}

# NUEVO: Controlador para el botón de STOP absoluto
handle_stop() {
    # 1. Ejecutamos el stop global para todos los reproductores o el principal
    playerctl stop >/dev/null 2>&1
    mpc stop >/dev/null 2>&1  # Aseguramos que MPD reciba el stop estricto si era un stream

    # 2. Aplicamos la purga de caché D-Bus para Firefox
    force_dbus_switch
}

# --- CONTROLADOR DE ARGUMENTOS ---
case "$1" in
    --toggle)
        handle_toggle
        ;;
    --stop)
        handle_stop
        ;;
    *)
        exit 1
        ;;
esac
