#!/bin/bash
set -x  # ← activa modo debug

active_ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).name')
echo "ACTIVE_WS: $active_ws"

workspaces=$(swaymsg -t get_workspaces | jq -r '.[].name')
echo "WORKSPACES: $workspaces"

tree=$(swaymsg -t get_tree)
echo "TREE LENGTH: ${#tree}"

for ws in $workspaces; do
    echo "Checking workspace $ws..."
    apps=$(echo "$tree" | jq -r --arg ws "$ws" '
        .. | objects
        | select(.type == "workspace" and .name == $ws)
        | .. | objects
        | select(.type == "con" and .app_id != null)
        | .app_id' | tr -d '"' | tr '[:upper:]' '[:lower:]')

    echo "Apps in $ws: $apps"
done
