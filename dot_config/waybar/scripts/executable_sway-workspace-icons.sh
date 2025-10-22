#!/bin/bash
trap '' SIGPIPE

# Iconos por aplicación
declare -A icons=(
    ["foot"]=""
    ["alacritty"]=""
    ["kitty"]="󰨊"
    ["firefox"]=""
    ["chromium"]=""
    ["brave"]=""
    ["thunar"]=""
    ["nemo"]=""
    ["vscode"]=""
    ["code"]=""
    ["discord"]=""
    ["telegram"]=""
    ["spotify"]=""
    ["mpv"]=""
    ["gimp"]=""
)

empty_icon="󰊠"
color_active="#ffffff"
color_inactive="#717593"
color_occupied="#C2A4F5"
separator="  "

update_icons() {
    active_ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).name')
    workspaces=$(swaymsg -t get_workspaces | jq -r '.[].name')
    tree=$(swaymsg -t get_tree)
    output=""

    for ws in $workspaces; do
        apps=$(echo "$tree" | jq -r --arg ws "$ws" '
            .. | objects
            | select(.type == "workspace" and .name == $ws)
            | .. | objects
            | select(.type == "con" and .app_id != null)
            | .app_id' | tr -d '"' | tr '[:upper:]' '[:lower:]')

        if [[ -n "$apps" ]]; then
            last_app=$(echo "$apps" | tail -n 1)
            icon="${icons[$last_app]:-$empty_icon}"
        else
            icon="$empty_icon"
        fi

        if [[ "$ws" == "$active_ws" ]]; then
            color=$color_active
        elif [[ -n "$apps" ]]; then
            color=$color_occupied
        else
            color=$color_inactive
        fi

        output+="<span color=\"$color\">$icon</span>$separator"
    done

    # Imprimir JSON correctamente escapado
    jq -nc --arg text "$output" --arg tooltip "Workspaces" \
        '{text: $text, tooltip: $tooltip}'
}

# Si Waybar lo ejecuta, escuchar eventos; si no, ejecutar una vez
if [[ -z "$WAYBAR_MODULE" ]]; then
    update_icons
else
    swaymsg -mt subscribe '["window","workspace"]' | while read -r _; do
        update_icons
    done
fi
