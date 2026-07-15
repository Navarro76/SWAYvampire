#!/bin/bash

#######################
#       VARIABLES
#######################

part1="/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1"
part2="/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2"
part3="/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part1"
#part4="/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part6"

mnt1="/mnt/Datos"
mnt2="/mnt/Navarro"
mnt3="/mnt/Archivos"
#mnt4="/mnt/Nueva"

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

# =====================================================================
# 1. LANZAMIENTO EN PARALELO (Todo arranca al mismo tiempo)
# =====================================================================

log "Iniciando montajes en paralelo..."

# Partición 1 (Datos)
mount -t ntfs-3g -o defaults,uid=1000,gid=1000,umask=0002,permissions "$part1" "$mnt1" 2>> "$LOG_FILE" &
PID1=$!

# Partición 2 (Navarro)
mount -t ntfs-3g -o defaults,uid=1000,gid=1000,umask=0002,permissions "$part2" "$mnt2" 2>> "$LOG_FILE" &
PID2=$!

# Partición 3 (Archivos)
mount -t xfs -o defaults "$part3" "$mnt3" 2>> "$LOG_FILE" &
PID3=$!

# Partición 4 (Nueva)
#mount -t xfs -o defaults "$part4" "$mnt4" 2>> "$LOG_FILE" &
#PID4=$!

# =====================================================================
# 2. ESPERA Y VERIFICACIÓN REAL
# =====================================================================
log "Esperando confirmación del hardware..."

# Verificación Partición 1
wait $PID1
if [ $? -eq 0 ]; then
    log "✓ Partición 1 (Datos) montada correctamente"
else
    log "✗ Error al montar Partición 1 (Datos)"
fi

# Verificación Partición 2
wait $PID2
if [ $? -eq 0 ]; then
    log "✓ Partición 2 (Navarro) montada correctamente"
else
    log "✗ Error al montar Partición 2 (Navarro)"
fi

# Verificación Partición 3
wait $PID3
if [ $? -eq 0 ]; then
    log "✓ Partición 3 (Archivos) montada correctamente"
else
    log "✗ Error al montar Partición 3 (Archivos)"
fi

# Verificación Partición 4
#wait $PID4
#if [ $? -eq 0 ]; then
#    log "✓ Partición 4 (Nueva) montada correctamente"
#else
#    log "✗ Error al montar Partición 4 (Nueva)"
#fi

#################################
#       VERIFICACIÓN FINAL
#################################

log "--- VERIFICACIÓN FINAL ---"

#for mnt in "$mnt1" "$mnt2" "$mnt3" "$mnt4"; do
for mnt in "$mnt1" "$mnt2" "$mnt3"; do
    if grep -qs "$mnt " /proc/mounts; then
        permisos=$(stat -c "%A %U:%G" "$mnt" 2>/dev/null)
        log "✓ $mnt: MONTADO ($permisos)"
    else
        log "✗ $mnt: NO MONTADO"
    fi
done

# Información adicional sobre sistemas de archivos montados
log "--- INFORMACIÓN DETALLADA ---"
#for mnt in "$mnt1" "$mnt2" "$mnt3" "$mnt4"; do
for mnt in "$mnt1" "$mnt2" "$mnt3"; do
    if grep -qs "$mnt" /proc/mounts; then
        fs_type=$(grep "$mnt" /proc/mounts | awk '{print $3}')
        log "SISTEMA: $mnt - Tipo: $fs_type"
    fi
done

log "Script de montaje completado"
