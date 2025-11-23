#!/bin/bash

# Montar discos
mount -t xfs /dev/disk/by-id/ata-ST8000VN004-3CP101_WRQ2G332-part1 /mnt/disk1 || echo "¡Error al montar /mnt/disk1!"
mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2 || echo "¡Error al montar /mnt/disk2!"
mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk3 || echo "¡Error al montar /mnt/disk3!"

# Verificar montaje exitoso
if grep -qs "/mnt/disk1" /proc/mounts && grep -qs "/mnt/disk2" /proc/mounts; then
    echo "Discos montados. Reiniciando Jellyfin..."

    # Solo hacer 'down' si hay contenedores corriendo
    if docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml ps | grep -q "Up"; then
        docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml down
    fi

    docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml up -d
else
    echo "¡Advertencia! No se montaron todos los discos. Jellyfin no se reiniciará."
fi
