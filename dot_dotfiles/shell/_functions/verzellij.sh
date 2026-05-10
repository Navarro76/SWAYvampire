verzellij() {
    local archivo="/home/alex/.dotfiles/shell/_ver/zellij.txt"
    local menu="ESC:SALIR | 1:PRINCIPALES | 2:RESIZE | 3:PANE | 4:MOVE | 5:TAB | 6:SCROLL | 7:SEARCH | 8:SESSION | 9:FLUJO | 0:TMUX"

    if [[ ! -f "$archivo" ]]; then
        echo "Error: No se encuentra el archivo en $archivo"
        return 1
    fi

    # --- CONFIGURACIÓN DE COLORES ---
    local c_txt_tit="15"    # Blanco
    local c_bg_tit="57"     # Morado
    local c_txt_neg="251"    # Rosa
    local c_txt_cmd="141"    # Turquesa
    local c_bg_cmd="234"    # Gris Oscuro
    local c_txt_norm="244"  # Gris claro (Asegúrate de que este sea el tono que te gusta)
    # --------------------------------

    local RENDER='awk -v tt="'$c_txt_tit'" -v tb="'$c_bg_tit'" -v nt="'$c_txt_neg'" -v ct="'$c_txt_cmd'" -v cb="'$c_bg_cmd'" -v tn="'$c_txt_norm'" '\''{

        # 1. Títulos
        if ($0 ~ /^#/) {
            sub(/^#[[:space:]]*/, "", $0);
            printf "\n\033[1;38;5;%sm\033[48;5;%sm  %s  \033[0m\n", tt, tb, $0
            next
        }

        # 2. Inicializamos la línea con el color base (tn)
        linea = $0

        # 3. Procesar CÓDIGO ( `texto` )
        # Usamos un bucle que no rompe la estructura de la línea
        while (match(linea, /`[^`]+`/)) {
            dentro = substr(linea, RSTART + 1, RLENGTH - 2)
            # Reemplazo sin espacios adicionales
            sustituto = "\033[38;5;" ct ";48;5;" cb "m" dentro "\033[0m\033[38;5;" tn "m"
            linea = substr(linea, 1, RSTART - 1) sustituto substr(linea, RSTART + RLENGTH)
        }

        # 4. Procesar NEGRITAS ( **texto** )
        while (match(linea, /\*\*[^*]+\*\*/)) {
            dentro = substr(linea, RSTART + 2, RLENGTH - 4)
            sustituto = "\033[1;38;5;" nt "m" dentro "\033[0m\033[38;5;" tn "m"
            linea = substr(linea, 1, RSTART - 1) sustituto substr(linea, RSTART + RLENGTH)
        }

        # 5. Imprimir asegurando que el color normal se mantenga
        printf "\033[38;5;%sm%s\033[0m\n", tn, linea
    }'\'''

    # Lanzamiento
    eval "sed -n \"/# PRINCIPALES/,/#/p\" \"$archivo\" | head -n -1" | eval "$RENDER" | fzf \
        --height 80% \
        --reverse \
        --ansi \
        --header "Guía: $menu" \
        --prompt="Filtro: " \
        --bind "1:reload(sed -n '/# PRINCIPALES/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "2:reload(sed -n '/# RESIZE/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "3:reload(sed -n '/# PANE/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "4:reload(sed -n '/# MOVE/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "5:reload(sed -n '/# TAB/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "6:reload(sed -n '/# SCROLL/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "7:reload(sed -n '/# SEARCH/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "8:reload(sed -n '/# SESSION/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "9:reload(sed -n '/# FLUJO/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "0:reload(sed -n '/# TMUX/,/#/p' $archivo | head -n -1 | $RENDER)" \
        --bind "ctrl-r:reload(cat $archivo | $RENDER)"

    # Esto limpia el código de salida de fzf (130) y devuelve 0 (éxito)
    return 0
}
