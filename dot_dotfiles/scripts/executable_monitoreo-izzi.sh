#!/bin/bash
echo "🕐 $(date)"
echo "📊 Test de velocidad Izzi 30 Mbps:"

# Test de velocidad con manejo de errores
if velocidad_mbps=$(curl -o /dev/null -w '%{speed_download}' -s https://proof.ovh.net/files/10Mb.dat 2>/dev/null | awk '{printf "%.2f Mbps\n", $1 * 8 / 1000000}'); then
    echo "Velocidad: $velocidad_mbps"
else
    echo "Velocidad: Error en la medición"
fi

# Test de ping
echo -n "📡 Ping: "
if ping_result=$(ping -c 2 8.8.8.8 2>/dev/null | tail -1 | awk -F'/' '{print $5 " ms"}'); then
    echo "$ping_result"
else
    echo "Error en ping"
fi

echo "---"
