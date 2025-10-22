#!/bin/bash
INTERFACE="ens33"
IPV4=$(ip -4 addr show $INTERFACE 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)

if [ -n "$IPV4" ]; then
    echo "{\"text\": \"󰊗 $IPV4\", \"tooltip\": \"Interface: $INTERFACE\"}"
else
    echo "{\"text\": \"󰖪 Sin conexión\", \"tooltip\": \"Interface: $INTERFACE - Desconectado\"}"
fi
