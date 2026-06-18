#!/usr/bin/env bash

iface="enp34s0"
state_file="/tmp/waybar_net_state"

rx_now=$(cat /sys/class/net/$iface/statistics/rx_bytes)
time_now=$(date +%s)

if [ -f "$state_file" ]; then
    read rx_prev time_prev avg_prev < "$state_file"
else
    echo "$rx_now $time_now 0" > "$state_file"
    printf '{"text":"󰈁 0 KB/s"}'
    exit 0
fi

delta_bytes=$((rx_now - rx_prev))
delta_time=$((time_now - time_prev))

if [ $delta_time -eq 0 ]; then
    speed=0
else
    speed=$((delta_bytes / delta_time))
fi

# Promedio móvil exponencial (suavizado)
alpha=0.2
avg=$(awk "BEGIN {print ($alpha * $speed) + ((1 - $alpha) * $avg_prev)}")

echo "$rx_now $time_now $avg" > "$state_file"

# Auto unidad
if (( $(awk "BEGIN {print ($avg >= 1048576)}") )); then
    output=$(awk "BEGIN {printf \"%.2f MB/s\", $avg/1024/1024}")
elif (( $(awk "BEGIN {print ($avg >= 1024)}") )); then
    output=$(awk "BEGIN {printf \"%.1f KB/s\", $avg/1024}")
else
    output=$(awk "BEGIN {printf \"%.0f B/s\", $avg}")
fi

printf '{"text":"󰈁 %s"}' "$output"
