# Cambiar partición 4 a /etc/fstab

## /etc/fstab

```bash
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# systemd generates mount units based on this file, see systemd.mount(5).
# Please run 'systemctl daemon-reload' after making changes here.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/nvme0n1p3 during installation
UUID=c6b3bcf9-6cd4-4cce-af2e-48c7d9b653ee /               ext4    errors=remount-ro 0       1
# /boot was on /dev/nvme0n1p1 during installation
#UUID=347064d6-1bfe-44b9-89a7-3e8bef99806d /boot           ext4    defaults        0       2
# /boot/efi was on /dev/nvme0n1p2 during installation
UUID=D419-5F8B /boot/efi       vfat    umask=0077      0       1
# /home was on /dev/sda7 during installation
UUID=548900f9-6a07-4863-9dad-408e433f236e /home           ext4    defaults        0       2
# /tmp was on /dev/sda5 during installation
UUID=d734f39a-5a3e-4592-b870-6a99677ebe51 /tmp            ext4    defaults        0       2
# /var was on /dev/sda6 during installation
UUID=f5595e29-45ed-4ae8-9595-789f97cc34ad /var            ext4    defaults        0       2

# Data Drivers
#/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2 /mnt/Archivos ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
#/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1 /mnt/Datos    ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
#/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2          /mnt/Navarro  ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
#/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4 /mnt/Nueva    xfs     defaults 0 0
```

Identificar la partición:

```bash
 lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 931.5G  0 disk
├─sda1   8:1    0     1G  0 part /boot/efi
├─sda2   8:2    0   100G  0 part /
├─sda3   8:3    0    40G  0 part /tmp
├─sda4   8:4    0    40G  0 part /var
├─sda5   8:5    0   200G  0 part /home
└─sda6   8:6    0 550.5G  0 part /mnt/Nueva
sdb      8:16   0   1.8T  0 disk
└─sdb1   8:17   0   1.8T  0 part /mnt/Datos
sdc      8:32   0 931.5G  0 disk
└─sdc1   8:33   0 931.5G  0 part /mnt/Archivos
sdd      8:48   0   3.6T  0 disk
├─sdd1   8:49   0    16M  0 part
└─sdd2   8:50   0   3.6T  0 part /mnt/Navarro
```

La partición es `sda6` montada en `/mnt/Nueva` utilizando el script que se encarga de montar las unidades.

Obtener los nuevos UUIDs

```bash
 lsblk -f /dev/sda
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1 vfat   FAT32       D419-5F8B                            1013.2M     1% /boot/efi
├─sda2 ext4   1.0         c6b3bcf9-6cd4-4cce-af2e-48c7d9b653ee   74.9G    18% /
├─sda3 ext4   1.0         d734f39a-5a3e-4592-b870-6a99677ebe51     37G     0% /tmp
├─sda4 ext4   1.0         f5595e29-45ed-4ae8-9595-789f97cc34ad   31.8G    13% /var
├─sda5 ext4   1.0         548900f9-6a07-4863-9dad-408e433f236e  130.1G    28% /home
└─sda6 xfs                13d6c29f-b25f-40c2-b5da-bba0ded4f2b0  358.9G    35% /mnt/Nueva
```

Actualizar el fstab del sistema nuevo

```bash
sudo nano /mnt/sistema_nuevo/etc/fstab
```

Con opciones optimizadas para no bloquear el arranque:

```bash
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during installation
UUID=c6b3bcf9-6cd4-4cce-af2e-48c7d9b653ee /               ext4    errors=remount-ro 0       1
# /boot was on /dev/nvme0n1p1 during installation
#UUID=347064d6-1bfe-44b9-89a7-3e8bef99806d /boot           ext4    defaults        0       2
# /boot/efi was on /dev/sda1 during installation
UUID=D419-5F8B /boot/efi       vfat    umask=0077      0       1
# /home was on /dev/sda5 during installation
UUID=548900f9-6a07-4863-9dad-408e433f236e /home           ext4    defaults        0       2
# /tmp was on /dev/sda3 during installation
UUID=d734f39a-5a3e-4592-b870-6a99677ebe51 /tmp            ext4    defaults        0       2
# /var was on /dev/sda4 during installation
UUID=f5595e29-45ed-4ae8-9595-789f97cc34ad /var            ext4    defaults        0       2
# /mnt/Nueva on /dev/sda6 during installation
# UUID=13d6c29f-b25f-40c2-b5da-bba0ded4f2b0 /mnt/Nueva xfs defaults,nofail,noatime,x-systemd.requires=local-fs.target 0 2
UUID=13d6c29f-b25f-40c2-b5da-bba0ded4f2b0 /mnt/Nueva xfs defaults,nofail,noatime,x-systemd.after=var.mount 0 2
```

- Quitamos `x-systemd.automount`: Ahora la partición se monta de verdad de forma síncrona durante el arranque del sistema, asegurando que cuando Podman despierte, los volúmenes XFS ya estén listos y expuestos con sus permisos correctos.
- `x-systemd.after`: Le dice a systemd: *"Sé que quieres montar todo en paralelo, pero por favor, no inicies el montaje de* `/mnt/Nueva` *hasta que la unidad* `var.mount` *esté completamente activa"*. Esto escalona el uso del bus mecánico del disco duro `/dev/sda`.
- `nofail`: Es vital mantenerlo. Si por alguna fluctuación física extrema del bus SATA el disco tarda en responder, el sistema operativo no detendrá el arranque con una pantalla de emergencia en la TTY; simplemente continuará y lo montará inmediatamente después.
- `x-systemd.requires=local-fs.target`: Esta directiva le asegura a systemd que el montaje debe sincronizarse de manera ordenada con los sistemas de archivos locales del sistema antes de pasar al espacio de usuario, dándole prioridad en la cola del bus mecánico.

**El veredicto de diseño**

La combinación más robusta para tu arquitectura actual (y que puedes reflejar limpiamente en tus playbooks de Ansible) es un modelo híbrido:

- **Para lo que muevas a** `/etc/fstab` **(Particiones 4):** Usa `UUID`. Es el estándar nativo de systemd y mantiene el archivo de configuración limpio y desacoplado del orden de los cables.
- **Para lo que se quede en tu Script de Montaje (Particiones 1 y 2 en NTFS/fuseblk):** Mantén `by-id`. Le da velocidad al script para comprobar el hardware en frío y sobrevive a cualquier mantenimiento o formateo que le hagas a las particiones de datos.

## 2. Limpiar el Script de Montaje

Abre tu script con nano o Neovim y elimina (o comenta por completo) no solo el comando `mount`, sino también las secciones de verificación, espera de hardware y el reporte final que correspondan a la partición 4.

El script debe quedar única y exclusivamente dedicado a los discos externos (`/mnt/Datos`, `/mnt/Navarro` y `/mnt/Archivos`). Al quitarle la carga de inspeccionar `/mnt/Nueva`, el script dejará de interponerse en el camino de `systemd`.

## 3. Ajustar las dependencias del Servicio de Montaje

Para asegurarnos de que tu script de usuario no intente verificar los puntos de montaje de los otros discos hasta que el sistema base en `/dev/sda` esté completamente estable, es buena idea revisar el archivo de servicio que lo dispara (`mount-disks.service`, probablemente ubicado en `/etc/systemd/system/`).

Asegúrate de que en su sección [Unit] esté configurado para correr después de los montajes locales críticos:

```bash
nano /etc/systemd/system/mount-disks.service
```

```bash
[Unit]
Description=Montar discos locales masivos en paralelo
DefaultDependencies=no
After=local-fs.target var.mount
Before=basic.target multi-user.target umount.target
Conflicts=umount.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mount-disks.sh
RemainAfterExit=yes

[Install]
WantedBy=local-fs.target
```

¿Qué corregimos aquí?

- `DefaultDependencies=no`: Por defecto, systemd hace que los servicios esperen a que el sistema esté casi completamente arriba. Al desactivar esto, le permitimos al script actuar en la fase temprana de almacenamiento, que es donde pertenece.
- `After=local-fs.target var.mount`: Le ordenamos explícitamente esperar a que `/dev/sda` haya terminado de montar la raíz y `/var`. Así, el disco de tu sistema operativo ya terminó su ráfaga inicial antes de que tu script toque los otros discos (`sdbp`, `sdc`, `sdd`).
- `Before=basic.target multi-user.target y WantedBy=local-fs.target`: Desplazamos el servicio hacia el pasado. Ahora el script se ejecuta y termina antes de que los servicios normales del usuario (como Podman, Sway o tu entorno gráfico) empiecen a pedir recursos.

Con este cambio en el servicio y la limpieza de la partición 4 dentro del `script mount-disks.sh`, vas a lograr que cada disco responda en su momento exacto, eliminando por completo los cuellos de botella mecánicos al arrancar. Recuerda ejecutar `sudo systemctl daemon-reload` después de guardar el archivo para que systemd aplique las nuevas reglas.

```bash
sudo systemctl daemon-reload
```

## 4. Asegurar que tus servicios de Podman esperen a /mnt/Nueva

Si tus contenedores de Podman se ejecutan como servicios de `systemd` (ya sea a nivel de sistema o de usuario), es crítico que estos servicios no intenten arrancar antes de que `/mnt/Nueva` esté montada. De lo contrario, se saltarán el montaje o fallarán al no encontrar los volúmenes.

Si usas archivos de servicio de systemd para tus contenedores (o para un script que los levanta), asegúrate de que el bloque `[Unit]` de esos servicios incluya lo siguiente:

```bash
[Unit]
Description=Mi Contenedor Podman
Requires=mnt-Nueva.mount
After=mnt-Nueva.mount
```

> **Nota sobre el nombre:** En `systemd`, los nombres de las unidades de montaje se derivan de la ruta de la carpeta, reemplazando las barras `/` por guiones. Por eso `/mnt/Nueva` se convierte en `mnt-Nueva.mount`.

**¡Los Quadlets cambian el panorama para bien!*+ Como sabes, los archivos `.container` son leídos por el generador de Podman (`podman-systemd-generator`) durante el arranque de `systemd` y transformados automáticamente en servicios nativos reales en memoria.

Aquí tienes cómo debe quedar tu Quadlet de Navidrome optimizado para la topografía de tus discos:

`~/.config/containers/systemd/navidrome.container`

```bash
[Unit]
Description=Servidor Navidrome (Quadlet)
After=network-online.target
# Forzamos al servicio generado a esperar que los montajes físicos estén listos
Requires=mnt-Nueva.mount mnt-Datos.mount mnt-Navarro.mount
After=mnt-Nueva.mount mnt-Datos.mount mnt-Navarro.mount

[X-Container]
# Esta es la forma correcta para que el generador inyecte la directiva en el .service real
TimeoutStartSec=300

[Container]
Image=docker.io/deluan/navidrome:latest
ContainerName=navidrome
PublishPort=4533:4533
Volume=/mnt/Datos/MUSIC:/music:ro
Volume=/mnt/Navarro/MUSIC:/music2:ro
Volume=/mnt/Nueva/Podman/navidrome/data:/data:U
Environment=ND_SCANSCHEDULE=1h ND_LOGLEVEL=info ND_SESSIONTIMEOUT=24h ND_BASEURL="" ND_ENABLEVFSWATCHER=true ND_ALBUMIDSTRATEGY=folder

[Install]
WantedBy=default.target
```

**¿Por qué esta es la solución definitiva con Quadlets?**

- **Evitas contenedores corruptos u vacíos:** Al declarar Requires y After con los nombres de las unidades de montaje de `systemd` (`mnt-Nueva.mount`, etc.), le prohíbes expresamente a Podman arrancar el contenedor si el disco mecánico `/dev/sda` o los discos de datos externos siguen ocupados o montándose.
- **Sincronización impecable:** Si combinas esto con el cambio anterior en el `/etc/fstab` (`x-systemd.after=var.mount`), la cadena de arranque en tu sesión de usuario queda perfectamente ordenada en fila india:

```bash
Arranque del Sistema ⟶ Montaje de /var ⟶ Montaje de /mnt/Nueva ⟶ Arranque del Quadlet Navidrome
```

- **Mantenimiento en Caliente:** Si alguna vez desmontas manualmente una de estas carpetas para mantenimiento de archivos, `systemd` sabrá de forma inteligente que debe detener temporalmente el contenedor de Navidrome para evitar errores de escritura y levantarlo de nuevo en cuanto la unidad vuelva a estar en línea.



Otros conteiners que me faltan:

```bash
 ls -l ~/.config/containers/systemd/
.rw-rw-r-- alex alex 406 B  Tue Apr 28 10:01:16 2026  gitea.container
.rw-rw-r-- alex alex 376 B  Mon Jun 29 17:23:50 2026  kavita.container
.rw-rw-r-- alex alex 651 B  Wed Jul  1 20:09:17 2026  manga-manager-backup.container
.rw-rw-r-- alex alex 745 B  Wed Jul  1 20:13:56 2026  manga-manager.container
.rw-rw-r-- alex alex 1.4 KB Tue Jul 14 16:30:22 2026  navidrome.container
```

## RESULTADO:

```bash
 systemd-analyze blame
4.522s hardinfo2.service
3.840s smartmontools.service
3.820s wtmpdb-update-boot.service
3.802s ifupdown-pre.service
3.682s udisks2.service
3.513s user@1000.service
3.328s accounts-daemon.service
3.084s virtlockd.service
2.984s virtlogd.service
2.971s NetworkManager.service
2.924s polkit.service
2.000s dev-sdb2.device
1.891s wpa_supplicant.service
1.682s avahi-daemon.service
1.677s dbus.service
1.656s mnt-Nueva.mount
1.473s rtkit-daemon.service
1.431s mount-disks.service
1.411s systemd-logind.service
1.355s systemd-machined.service
1.179s systemd-journal-flush.service
1.178s ModemManager.service
1.174s systemd-fsck@dev-disk-by\x2duuid-D419\x2d5F8B.service
1.146s grub-common.service
1.108s systemd-fsck@dev-disk-by\x2duuid-d734f39a\x2d5a3e\x2d4592\x2db870\x2d6a99677ebe51.service
1.073s networking.service
1.071s privoxy.service
. . . 

 nano /var/log/ultimo_montaje.log

=== REGISTRO DE MONTAJE - mar 14 jul 2026 17:12:21 CST ===
[2026-07-14 17:12:21] Iniciando script de montaje...
[2026-07-14 17:12:21] Verificando puntos de montaje...
[2026-07-14 17:12:21] Creando directorio ...
[2026-07-14 17:12:21] Iniciando montajes en paralelo...
[2026-07-14 17:12:21] Esperando confirmación del hardware...
[2026-07-14 17:12:22] ✓ Partición 1 (Datos) montada correctamente
[2026-07-14 17:12:22] ✓ Partición 2 (Navarro) montada correctamente
[2026-07-14 17:12:22] ✓ Partición 3 (Archivos) montada correctamente
[2026-07-14 17:12:22] --- VERIFICACIÓN FINAL ---
[2026-07-14 17:12:22] ✓ /mnt/Datos: MONTADO (drwxrwxr-x alex:alex)
[2026-07-14 17:12:22] ✓ /mnt/Navarro: MONTADO (drwxrwxr-x alex:alex)
[2026-07-14 17:12:22] ✓ /mnt/Archivos: MONTADO (drwxrwxr-x alex:alex)
[2026-07-14 17:12:22] --- INFORMACIÓN DETALLADA ---
[2026-07-14 17:12:22] SISTEMA: /mnt/Datos - Tipo: fuseblk
[2026-07-14 17:12:22] SISTEMA: /mnt/Navarro - Tipo: fuseblk
[2026-07-14 17:12:22] SISTEMA: /mnt/Archivos - Tipo: xfs
[2026-07-14 17:12:22] Script de montaje completado
```

¡Qué abismal diferencia, Alex! Mírate esos números, el cambio valió la pena por completo. El arranque de tu máquina dio un giro radical:

### 1. El veredicto del tiempo

- **`mnt-Nueva.mount`**: Bajó de 2.530s a **1.656s**.

- **`mount-disks.service`**: Bajó de 2.484s a **1.431s**.

- **El script en paralelo**: ¡Tarda exactamente **1 segundo** en verificar y confirmar los tres discos masivos (`Datos`, `Navarro`, `Archivos`)! Pasó de aquellos 9 segundos iniciales a terminar de forma instantánea.

### 2. Por qué esta estructura es una roca

Al mover el servicio hacia la fase temprana (`WantedBy=local-fs.target`) y limpiar la sobrecarga de la partición 4 del script, lograste que el disco mecánico `/dev/sda` leyera `/mnt/Nueva` de forma nativa sin competir contra sí mismo.

El script ahora despierta en su propio hilo temporal exclusivo para revisar los otros buses controladores (`sdb`, `sdc`, `sdd`), confirmando el hardware masivo en paralelo mientras el sistema operativo termina de levantar el espacio de usuario limpio.

Con esto, tus contenedores mapeados a través de Quadlets en Podman ya tienen su base de datos lista y disponible en `/mnt/Nueva` desde el milisegundo uno, eliminando cualquier posibilidad de directorios vacíos o errores al levantar tus servicios multimedia. ¡Misión cumplida con la optimización del almacenamiento en frío!

## Archivos finales

`/etc/fstab`

```bash
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# systemd generates mount units based on this file, see systemd.mount(5).
# Please run 'systemctl daemon-reload' after making changes here.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during installation
UUID=c6b3bcf9-6cd4-4cce-af2e-48c7d9b653ee /               ext4    errors=remount-ro 0       1
# /boot was on /dev/nvme0n1p1 during installation
#UUID=347064d6-1bfe-44b9-89a7-3e8bef99806d /boot           ext4    defaults        0       2
# /boot/efi was on /dev/sda1 during installation
UUID=D419-5F8B /boot/efi       vfat    umask=0077      0       1
# /home was on /dev/sda5 during installation
UUID=548900f9-6a07-4863-9dad-408e433f236e /home           ext4    defaults        0       2
# /tmp was on /dev/sda3 during installation
UUID=d734f39a-5a3e-4592-b870-6a99677ebe51 /tmp            ext4    defaults        0       2
# /var was on /dev/sda4 during installation
UUID=f5595e29-45ed-4ae8-9595-789f97cc34ad /var            ext4    defaults        0       2
# /mnt/Nueva on /dev/sda6 during installation
#UUID=13d6c29f-b25f-40c2-b5da-bba0ded4f2b0 /mnt/Nueva xfs defaults,nofail,noatime,x-systemd.requires=local-fs.target 0 2
UUID=13d6c29f-b25f-40c2-b5da-bba0ded4f2b0 /mnt/Nueva xfs defaults,nofail,noatime,x-systemd.after=var.mount 0 2

# Data Drivers
#/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2 /mnt/Archivos ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
#/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1 /mnt/Datos    ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
#/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2          /mnt/Navarro  ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
#/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4 /mnt/Nueva    xfs     defaults 0 0
```

`/etc/systemd/system/mount-disks.service`

```bash
[Unit]
Description=Montar discos locales masivos en paralelo
DefaultDependencies=no
After=local-fs.target var.mount
Before=basic.target multi-user.target umount.target
Conflicts=umount.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mount-disks.sh
RemainAfterExit=yes

[Install]
WantedBy=local-fs.target
```

`/usr/local/bin/mount-disks.sh`

```bash
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
```

PENDIENTES:

- commits de chezmoi de los archivos actuales sin modificar de los  .dotfiles para montar los discos

- copiar los archivos en uso a .dotfiles

- nuevo commit con los ultimos cambios de .dotfiles 

- 
