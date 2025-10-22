#!/bin/bash

# Define iconos para cada aplicación
declare -A icons
icons=( 
    ["firefox"]="" 
    ["navigator"]=""  
    ["firefox-esr"]=""
    ["brave"]=""
    ["chromium"]=""
    ["chromium-browser"]=""
    ["alacritty"]=""
    ["kitty"]="󰨊"
    ["thunar"]=""
    ["spacefm"]="󰉋"
    ["pcmanfm"]=""
    ["nemo"]=""
    ["geany"]="󰈙"
    ["vscode"]=""
    ["code"]=""
    ["deadbeef"]=""    
    ["cantata"]="󰝚"    
    ["sigil"]=""
    ["smplayer"]="󰕼"   
    ["vlc"]="󰕼"
    ["mpv"]=""
    ["calibre"]="󱓷"
    ["discord"]=""
    ["telegram"]=""
    ["steam"]=""
    ["spotify"]=""
    ["gimp"]=""
)

# Icono para escritorios vacíos
empty_icon="󰊠"

# Separador entre iconos
separator="  "

# Suscribirse a eventos de Sway
swaymsg -t subscribe -m '["window", "workspace"]' | while read -r line; do
    output=""
    active_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
    
    # Obtener todos los workspaces
    workspaces=$(swaymsg -t get_workspaces | jq -r '.[] | .name' | sort -V)
    
    for workspace in $workspaces; do
        # Verificar si el workspace tiene ventanas
        windows=$(swaymsg -t get_tree | jq -r ".nodes[].nodes[].nodes[] | select(.name==\"$workspace\") | .nodes[] | .app_id // .window_properties.class")
        
        if [[ -n "$windows" ]]; then
            # Obtener la primera aplicación del workspace
            first_app=$(echo "$windows" | head -n 1 | tr '[:upper:]' '[:lower:]')
            icon="${icons[$first_app]:-$empty_icon}"
        else
            icon="$empty_icon"
        fi

        # Aplicar separación entre iconos
        icon_content=" $icon $separator"

        # Definir clase CSS según estado del workspace
        if [[ "$workspace" == "$active_workspace" ]]; then
            output+="<span class='workspace-active'>$icon_content</span>"
        elif [[ -n "$windows" ]]; then
            output+="<span class='workspace-with-apps'>$icon_content</span>"
        else
            output+="<span class='workspace-inactive'>$icon_content</span>"
        fi
    done

    # Output en formato JSON para Waybar
    echo "{\"text\": \"$output\", \"tooltip\": \"\"}"
done
