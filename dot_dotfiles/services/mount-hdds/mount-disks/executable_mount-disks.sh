#!/bin/bash

#######################
#       VARIABLES
#######################

part1="/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2"
part2="/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1"
part3="/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2"
part4="/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4"

mnt1="/mnt/Archivos"
mnt2="/mnt/Datos"
mnt3="/mnt/Navarro"
mnt4="/mnt/Nueva"

###################
#       LOGS
###################

# Configuración del log (se sobrescribe en cada reinicio)
LOG_FILE="/var/log/ultimo_montaje.log"

# Función para escribir en el log (solo escribe en el archivo, no muestra en pantalla)
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Iniciar nuevo log (sobrescribir)
echo "=== REGISTRO DE MONTAJE - $(date) ===" > "$LOG_FILE"
log "Iniciando script de montaje..."

###############################
#       PUNTOS DE MONTAJE
###############################

log "Verificando puntos de montaje..."

# Verificar y crear puntos de montaje si no existen
for mnt in "$mnt1" "$mnt2" "$mnt3" "$mnt4"; do
    if [ ! -d "$mnt" ]; then
        log "Creando directorio $mnt..."
        mkdir -p "$mnt"
    fi
done

####################################
#       MONTAJE DE PARTICIONES
####################################

# Montar particiones NTFS con permisos específicos
log "Montando partición 1 (Archivos)..."
if mount -t ntfs-3g -o defaults,uid=1000,gid=1000,umask=0002,permissions "$part1" "$mnt1" 2>> "$LOG_FILE"; then
    log "✓ Partición 1 (Archivos) montada correctamente"
else
    log "✗ Error al montar Partición 1 (Archivos)"
fi

log "Montando partición 2 (Datos)..."
if mount -t ntfs-3g -o defaults,uid=1000,gid=1000,umask=0002,permissions "$part2" "$mnt2" 2>> "$LOG_FILE"; then
    log "✓ Partición 2 (Datos) montada correctamente"
else
    log "✗ Error al montar Partición 2 (Datos)"
fi

log "Montando partición 3 (Navarro)..."
if mount -t ntfs-3g -o defaults,uid=1000,gid=1000,umask=0002,permissions "$part3" "$mnt3" 2>> "$LOG_FILE"; then
    log "✓ Partición 3 (Navarro) montada correctamente"
else
    log "✗ Error al montar Partición 3 (Navarro)"
fi

log "Montando partición 4 (Nueva)..."
if mount -t xfs -o defaults "$part4" "$mnt4" 2>> "$LOG_FILE"; then
    log "✓ Partición 4 (Nueva) montada correctamente"
else
    log "✗ Error al montar Partición 4 (Nueva)"
fi

#################################
#       VERIFICACIÓN FINAL
#################################

log "--- VERIFICACIÓN FINAL ---"

for mnt in "$mnt1" "$mnt2" "$mnt3" "$mnt4"; do
    if grep -qs "$mnt" /proc/mounts; then
        permisos=$(stat -c "%A %U:%G" "$mnt" 2>/dev/null)
        log "✓ $mnt: MONTADO ($permisos)"
    else
        log "✗ $mnt: NO MONTADO"
    fi
done

# Información adicional sobre sistemas de archivos montados
log "--- INFORMACIÓN DETALLADA ---"
for mnt in "$mnt1" "$mnt2" "$mnt3" "$mnt4"; do
    if grep -qs "$mnt" /proc/mounts; then
        fs_type=$(grep "$mnt" /proc/mounts | awk '{print $3}')
        log "SISTEMA: $mnt - Tipo: $fs_type"
    fi
done

log "Script de montaje completado"
