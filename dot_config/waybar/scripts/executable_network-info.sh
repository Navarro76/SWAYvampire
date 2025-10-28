#!/usr/bin/env bash

iface=$(ip route | awk '/default/ {print $5}' | head -1)
ip4=$(ip -4 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1 || echo N/A)
ip6=$(ip -6 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet6\s)[0-9a-f:]+' | head -1 || echo N/A)
mac=$(cat /sys/class/net/"$iface"/address 2>/dev/null || echo N/A)
gw=$(ip route | grep default | awk '{print $3}' | head -1 || echo N/A)

if iw dev 2>/dev/null | grep -q "Interface $iface"; then
    ssid=$(iwgetid -r 2>/dev/null || echo N/A)
    signal=$(iwconfig "$iface" 2>/dev/null | grep -oP 'Signal level=\K[-0-9]+' || echo N/A)
    tooltip="Interface: $iface\\nIPv4: $ip4\\nIPv6: $ip6\\nGateway: $gw\\nMAC: $mac\\nSSID: $ssid\\nSignal: ${signal} dBm"
else
    tooltip="Interface: $iface\\nIPv4: $ip4\\nIPv6: $ip6\\nGateway: $gw\\nMAC: $mac"
fi

# ✅ Importante: no uses echo (añade salto de línea)
printf '{"text":" %s","tooltip":"%s"}' "$ip4" "$tooltip"
