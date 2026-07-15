#!/usr/bin/env bash

iface="enp34s0"
state_file="/tmp/waybar_net_state"

# Verificar si la interfaz existe para evitar errores raros
if [ ! -d "/sys/class/net/$iface" ]; then
    printf '{"text":"󰈁 Desconectado"}'
    exit 0
fi

rx_now=$(cat /sys/class/net/$iface/statistics/rx_bytes)
time_now=$(date +%s)

if [ -f "$state_file" ]; then
    read -r rx_prev time_prev avg_prev < "$state_file"
    # Defensa: Si alguna variable quedó vacía por corrupción, se asigna un valor por defecto
    rx_prev=${rx_prev:-$rx_now}
    time_prev=${time_prev:-$time_now}
    avg_prev=${avg_prev:-0}
else
    echo "$rx_now $time_now 0" > "$state_file"
    printf '{"text":"󰈁 0 B/s"}'
    exit 0
fi

delta_bytes=$((rx_now - rx_prev))
delta_time=$((time_now - time_prev))

if [ "$delta_time" -le 0 ]; then
    speed=0
else
    speed=$((delta_bytes / delta_time))
fi

# Promedio móvil exponencial (suavizado)
alpha=0.2
# Pasamos las variables con -v para que awk nunca lance un Syntax Error
avg=$(awk -v a="$alpha" -v s="$speed" -v ap="$avg_prev" 'BEGIN {print (a * s) + ((1 - a) * ap)}')

echo "$rx_now $time_now $avg" > "$state_file"

# Auto unidad (Manejado de forma nativa en Bash y un solo AWK al final para dar formato)
if (( $(awk -v avg="$avg" 'BEGIN {print (avg >= 1048576)}') )); then
    output=$(awk -v avg="$avg" 'BEGIN {printf "%.2f MB/s", avg/1024/1024}')
elif (( $(awk -v avg="$avg" 'BEGIN {print (avg >= 1024)}') )); then
    output=$(awk -v avg="$avg" 'BEGIN {printf "%.1f KB/s", avg/1024}')
else
    output=$(awk -v avg="$avg" 'BEGIN {printf "%.0f B/s", avg}')
fi

printf '{"text":"󰈁 %s"}' "$output"
