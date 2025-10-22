#!/bin/bash

echo "=== INICIANDO DEPURACIÓN ===" > /tmp/sway-debug.log

# Probar swaymsg básico
echo "1. Probando swaymsg get_workspaces:" >> /tmp/sway-debug.log
swaymsg -t get_workspaces >> /tmp/sway-debug.log 2>&1
echo "---" >> /tmp/sway-debug.log

echo "2. Probando swaymsg get_tree:" >> /tmp/sway-debug.log
swaymsg -t get_tree | head -20 >> /tmp/sway-debug.log 2>&1
echo "---" >> /tmp/sway-debug.log

# Probar jq
echo "3. Probando jq con workspaces:" >> /tmp/sway-debug.log
swaymsg -t get_workspaces | jq -r '.[] | "Workspace: \(.name) Focused: \(.focused)"' >> /tmp/sway-debug.log 2>&1
echo "---" >> /tmp/sway-debug.log

echo "=== FIN DEPURACIÓN ===" >> /tmp/sway-debug.log

# Mostrar resultado
cat /tmp/sway-debug.log
