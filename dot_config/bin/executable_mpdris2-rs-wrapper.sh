#!/bin/bash
# Esperar a que D-Bus esté disponible
while [ ! -S "/run/user/$(id -u)/bus" ]; do
    sleep 1
done
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Detener reproducción automática
mpc stop >/dev/null 2>&1

# Iniciar mpdris2-rs
exec /usr/local/bin/mpdris2-rs "$@"
