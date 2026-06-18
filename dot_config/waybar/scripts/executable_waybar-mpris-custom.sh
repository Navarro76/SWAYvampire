#!/bin/bash

# =====================================================================
# CONFIGURACIÓN Y VARIABLES GLOBALES
# =====================================================================
MAX_LEN=40
ICON_STOPPED="  Music Is Live"
ICON_PLAYING=""
ICON_PAUSED=""

# =====================================================================
# CAPA 1: TAREAS DE BAJO NIVEL (DRIVERS Y ESCÁNER JERÁRQUICO)
# =====================================================================

get_status_of() { playerctl --player="$1" status 2>/dev/null | xargs; }

is_mpd_stream() {
    [[ "$(mpc -f %file% current 2>/dev/null)" =~ :// ]] && echo 1 || echo 0
}

# El corazón del script: Escanea el bus buscando el reproductor más activo
get_targeted_player() {
    local players=$(playerctl -l 2>/dev/null)
    [ -z "$players" ] && { echo "mpd"; return; }

    # 1. Prioridad Máxima: El que esté reproduciendo AHORA (Playing real)
    for p in $players; do
        if [ "$(get_status_of "$p")" = "Playing" ]; then
            # Si es DeaDBeeF zombi (muriendo tras un stop sin título), lo saltamos
            local meta=$(playerctl --player="$p" metadata -f "{{ title }}{{ xesam:url }}" 2>/dev/null)
            if [ -n "$meta" ] || [ "$p" = "mpd" ]; then
                echo "$p"
                return
            fi
        fi
    done

    # 2. Segunda Prioridad: Si nadie suena, el que esté en Pausa (Paused)
    for p in $players; do
        if [ "$(get_status_of "$p")" = "Paused" ]; then
            echo "$p"
            return
        fi
    done

    # 3. Tercera Prioridad: Si todo está muerto, el primero disponible que no sea MPD
    for p in $players; do
        [ "$p" != "mpd" ] && { echo "$p"; return; }
    done

    echo "mpd"
}

cmd_stop_mpd() {
    mpc stop >/dev/null 2>&1
    playerctl --player=mpd stop >/dev/null 2>&1
}

cmd_stop_player()    { playerctl --player="$1" stop >/dev/null 2>&1; }
cmd_toggle_player()  { playerctl --player="$1" play-pause >/dev/null 2>&1; }
cmd_play_player()    { playerctl --player="$1" play >/dev/null 2>&1; }
cmd_next_player()    { playerctl --player="$1" next >/dev/null 2>&1; }
cmd_prev_player()    { playerctl --player="$1" previous >/dev/null 2>&1; }

# =====================================================================
# CAPA 2: LÓGICA DE FLUJO (MATRIZ DE ESTADOS DIRECCIONADA)
# =====================================================================

# Flujo A: Clic izquierdo en la barra
flow_click_toggle() {
    local target=$(get_targeted_player)
    local status=$(get_status_of "$target")

    if [ "$status" = "Playing" ]; then
        if [ "$target" = "mpd" ] && [ "$(is_mpd_stream)" -eq 1 ]; then
            cmd_stop_mpd
        else
            cmd_toggle_player "$target"
        fi
    else
        cmd_play_player "$target"
    fi
}

# Flujo B: Atajo físico de Play/Pause (Teclado)
# Si cambiaste a Firefox, target será Firefox. Si Firefox se pausa, target mantendrá a Firefox.
flow_key_toggle() {
    cmd_toggle_player "$(get_targeted_player)"
}

# Flujo C: Atajo físico de Stop (Teclado)
flow_key_stop() {
    local target=$(get_targeted_player)
    local status=$(get_status_of "$target")

    if [ "$target" = "mpd" ] && { [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; }; then
        cmd_stop_mpd
    else
        cmd_stop_player "$target"
    fi
}

# Flujos D y E: Saltos de pista dirigidos
flow_next() { cmd_next_player "$(get_targeted_player)"; }
flow_prev() { cmd_prev_player "$(get_targeted_player)"; }

# =====================================================================
# CAPA 3: RENDERIZADO PASIVO DE LA BARRA (WAYBAR)
# =====================================================================

flow_render_json() {
    local target=$(get_targeted_player)
    local status=$(get_status_of "$target")

    # Si el objetivo resuelto está completamente detenido o no es válido
    if [ "$status" = "Stopped" ] || [ -z "$status" ]; then
        echo "{\"text\": \"$ICON_STOPPED\", \"class\": \"stopped\"}"; return
    fi

    # Extraer metadata exclusiva del reproductor objetivo
    local raw_data=$(playerctl --player="$target" metadata -f "{{ playerName }}||{{ title }}||{{ artist }}||{{ xesam:url }}" 2>/dev/null)
    IFS="||" read -r P_NAME TITLE ARTIST URL <<< "$raw_data"
    P_NAME=$(echo "$P_NAME" | xargs); TITLE=$(echo "$TITLE" | xargs)
    ARTIST=$(echo "$ARTIST" | xargs); URL=$(echo "$URL" | xargs)

    # Filtro específico para DeaDBeeF ocioso/vacío
    if [[ "$P_NAME" == *"deadbeef"* ]] && [ -z "$TITLE" ] && [ -z "$URL" ]; then
        echo "{\"text\": \"$ICON_STOPPED\", \"class\": \"stopped\"}"; return
    fi

    # 1. ASIGNACIÓN DINÁMICA DEL ICONO DE LA APLICACIÓN
    local APP_ICON="" # Icono genérico de respaldo (Nota musical)
    local P_NAME_LOWER="${P_NAME,,}" # Convertimos a minúsculas para evitar fallos de coincidencia

    if [[ "$P_NAME_LOWER" == *"deadbeef"* ]]; then
        APP_ICON="󰋍" # Disco de vinilo / Reproductor (Nerd Fonts)
    elif [[ "$P_NAME_LOWER" == *"firefox"* ]]; then
        APP_ICON="" # Icono nativo de Firefox (Font Awesome)
    elif [[ "$P_NAME_LOWER" == *"chrome"* ]] || [[ "$P_NAME_LOWER" == *"chromium"* ]]; then
        APP_ICON="" # Icono de Chrome/Chromium (Font Awesome)
    elif [[ "$P_NAME_LOWER" == *"vlc"* ]]; then
        APP_ICON="󰕼" # Cono de tráfico clásico de VLC (Nerd Fonts)
    elif [[ "$P_NAME_LOWER" == *"mpv"* ]]; then
        APP_ICON="" # Icono oficial de MPV integrado en Nerd Fonts recientes (o usa 󰕧)
    elif [[ "$P_NAME_LOWER" == *"smplayer"* ]] || [[ "$P_NAME_LOWER" == *"mplayer"* ]]; then
        APP_ICON="󰨜" # Claqueta de cine / Reproductor multimedia (Nerd Fonts)
    elif [[ "$P_NAME_LOWER" == *"spotify"* ]]; then
        APP_ICON="" # Icono nativo de Spotify (Font Awesome)
    elif [[ "$P_NAME_LOWER" == *"mpd"* ]]; then
        APP_ICON=""  # Nota musical para tu servicio MPD base
    fi

    # Configuración de estilos según estado
    if [ "$status" = "Playing" ]; then
        S_ICON=$ICON_PLAYING; CSS_CLASS="playing"; F_START=""; F_END=""
    else
        S_ICON=$ICON_PAUSED; CSS_CLASS="paused"; F_START="<i>"; F_END="</i>"
    fi

    # Construcción de la cadena de texto (Metadata limpia)
    if [ -n "$TITLE" ] && [ -n "$ARTIST" ]; then FULL_TEXT="$TITLE - $ARTIST"
    elif [ -n "$TITLE" ]; then FULL_TEXT="$TITLE"
    elif [ -n "$ARTIST" ]; then FULL_TEXT="$ARTIST"
    elif [ -n "$URL" ]; then FULL_TEXT=$(basename "$URL" | sed 's/%20/ /g')
    else FULL_TEXT="Música Activa"; fi

    [ ${#FULL_TEXT} -gt $MAX_LEN ] && FULL_TEXT="${FULL_TEXT:0:$MAX_LEN}..."
    FULL_TEXT=$(echo "$FULL_TEXT" | sed 's/"/\\"/g')

    # 2. RENDERIZADO SIN ESPACIOS REPETIDOS
    # Formato: [Icono App] [Icono Estado] [Texto] -> Ej:   Título - Artista
    echo "{\"text\": \"$APP_ICON $S_ICON $F_START$FULL_TEXT$F_END\", \"class\": \"$CSS_CLASS\"}"
}

# =====================================================================
# EL MAIN (ENRUTADOR CENTRAL)
# =====================================================================
case "$1" in
    --click-toggle) flow_click_toggle ;;
    --key-toggle)   flow_key_toggle ;;
    --key-stop)     flow_key_stop ;;
    --next)         flow_next ;;
    --prev)         flow_prev ;;
    *)              flow_render_json ;;
esac
