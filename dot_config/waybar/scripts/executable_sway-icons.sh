#!/bin/bash

# Define iconos para cada workspace
declare -A workspace_icons
workspace_icons=(
    ["1"]=""   # Icono para workspace 1
    ["2"]="ﬦ"   # Icono para workspace 2  
    ["3"]=""   # Icono para workspace 3
    ["4"]=""   # Icono para workspace 4
    ["5"]=""   # Icono para workspace 5
)

default_icon="󰊠"

# Función principal
main_loop() {
    while true; do
        output=""
        
        # Obtener workspaces activos de forma segura
        active_workspaces=$(timeout 1 swaymsg -t get_workspaces 2>/dev/null | jq -r '.[] | "\(.name)"' 2>/dev/null)
        focused_workspace=$(timeout 1 swaymsg -t get_workspaces 2>/dev/null | jq -r '.[] | select(.focused==true) | .name' 2>/dev/null)
        
        # Mostrar workspaces 1 al 5
        for ws in 1 2 3 4 5; do
            icon="${workspace_icons[$ws]:-$default_icon}"
            
            # Verificar si el workspace está activo
            if echo "$active_workspaces" | grep -q "^$ws$" 2>/dev/null; then
                # Workspace activo - verificar si está enfocado
                if [[ "$ws" == "$focused_workspace" ]]; then
                    output+="<span class='workspace-active'> $icon </span>"
                else
                    output+="<span class='workspace-with-apps'> $icon </span>"
                fi
            else
                # Workspace inactivo
                output+="<span class='workspace-inactive'> $icon </span>"
            fi
        done
        
        # Intentar enviar output, si falla salir silenciosamente
        if ! echo "{\"text\": \"$output\"}" 2>/dev/null; then
            exit 0
        fi
        
        sleep 2
    done
}

# Ejecutar con manejo de señales
trap 'exit 0' TERM INT
main_loop
