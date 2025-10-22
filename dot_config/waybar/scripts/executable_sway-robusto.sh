#!/bin/bash

trap '' PIPE

# Define iconos para cada aplicación
declare -A icons
icons=(
    ["firefox"]=""
    ["brave"]=""
    ["chromium"]=""
    ["alacritty"]=""
    ["kitty"]="󰨊"
    ["thunar"]=""
    ["code"]=""
    ["vlc"]="󰕼"
    ["mpv"]=""
    ["discord"]=""
    ["telegram"]=""
    ["steam"]=""
    ["spotify"]=""
    ["gimp"]=""
)

default_icon="󰊠"

while true; do
    output=""

    # Obtener workspaces de forma más robusta
    if workspaces_data=$(timeout 2 swaymsg -t get_workspaces 2>/dev/null); then
        if [[ -n "$workspaces_data" ]]; then
            # Parsear workspaces
            while IFS= read -r line; do
                if [[ -n "$line" ]]; then
                    workspace_name=$(echo "$line" | awk '{print $1}')
                    is_focused=$(echo "$line" | awk '{print $2}')

                    # Para debugging simple, usar diferentes números
                    case "$workspace_name" in
                        "1") icon="" ;;
                        "2") icon="ﬦ" ;;
                        "3") icon="" ;;
                        "4") icon="" ;;
                        "5") icon="" ;;
                        *) icon="$default_icon" ;;
                    esac

                    # Aplicar estilos
                    if [[ "$is_focused" == "true" ]]; then
                        output+="<span class='workspace-active'> $icon </span>"
                    else
                        output+="<span class='workspace-inactive'> $icon </span>"
                    fi
                fi
            done < <(echo "$workspaces_data" | jq -r '.[] | "\(.name) \(.focused)"' 2>/dev/null)
        fi
    fi

    # Si hay output, mostrarlo
    if [[ -n "$output" ]]; then
        echo "{\"text\": \"$output\"}"
    else
        # Fallback con workspaces 1-3 como ejemplo
        echo "{\"text\": \"<span class='workspace-inactive'>  </span><span class='workspace-inactive'> ﬦ </span><span class='workspace-inactive'>  </span>\"}"
    fi

    sleep 3
done
